# frozen_string_literal: true

class Game < ApplicationRecord
  scope :available,
        -> { where('white_player_id is NULL or black_player_id is NULL') }
  has_many :pieces
  belongs_to :user
  enum status: %w[white_turn black_turn white_won black_won stalemate]
  self.per_page = 15

  validates :name, uniqueness: true, length: { minimum: 3, maximum: 60 }

  def self.games_for(player)
    where('black_player_id = ? OR white_player_id = ?', player.id, player.id)
  end

  def piece_at(xpos, ypos)
    pieces.filter { |p| p.at_coord?(xpos, ypos) }.first
  end

  def pieces_for(color)
    pieces.filter { |p| p.color == color && p.on_board? }
  end

  def check?(color)
    king = pieces_for(color).filter { |p| p.type == 'King' }.first
    king&.opponent_pieces&.any? { |p| p.can_take?(king) }
  end

  def turn_color
    return :white if white_turn?
    return :black if black_turn?
  end

  def opposite_color(color = turn_color)
    return :black if color == :white
    return :white if color == :black
  end

  def finish_turn
    pieces.reload
    change_turn!
    return unless no_moves?

    winner = check?(turn_color) ? opposite_color : nil

    record_winner(winner)
  end

  def change_turn!
    return white_turn! if black_turn?
    return black_turn! if white_turn?
  end

  def no_moves?
    pieces_for(turn_color).all? { |p| p.valid_moves.empty? }
  end

  def win_status
    black_turn? ? :white_won : :black_won
  end

  def record_winner(color)
    return stalemate! unless color
    return white_won! if color == :white
    return black_won! if color == :black
  end

  def forfeit(player_id)
    if player_id == black_player_id
      return stalemate! if player_id == white_player_id

      return white_won!
    end

    return black_won! if player_id == white_player_id

    false
  end

  def populate!(type = 'classic')
    raise 'Game already populated' unless pieces.empty?

    piece_order = [Rook, Knight, Bishop, Queen, King, Bishop, Knight, Rook]
    piece_order.shuffle! if type == '960'

    populate((0..7).to_a.reverse, [7, 6], :white, piece_order)
    populate((0..7).to_a, [0, 1], :black, piece_order)
  end

  private

  def populate(x_coords, y_coords, color = :white, piece_order)
    x_coords.each do |x|
      pieces << piece_order[x].create(white: color == :white,
                                      x_position: x,
                                      y_position: y_coords[0])
      pieces << Pawn.create(white: color == :white,
                            x_position: x,
                            y_position: y_coords[1])
    end
  end
end
