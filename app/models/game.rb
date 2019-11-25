# frozen_string_literal: true

class Game < ApplicationRecord
  scope :available,
        -> { where('white_player_id is NULL or black_player_id is NULL') }
  has_many :pieces
  belongs_to :user

  validates :name, uniqueness: true, length: { minimum: 3, maximum: 60 }

  def populate!
    raise 'Need both players' unless white_player_id && black_player_id
    raise 'Game already populated' unless pieces.empty?

    populate((0..7).to_a.reverse, [7, 6], :white)
    populate((0..7).to_a, [0, 1], :black)
  end

  def piece_at(xpos, ypos)
    pieces.filter { |p| p.at_coord?(xpos, ypos) }.first
  end

  def pieces_for(white)
    pieces.filter { |p| p.white == white }
  end

  def check?(color)
    white = color == :white

    king = pieces_for(white).filter { |p| p.type == 'King' }.first
    pieces_for(!white).any? { |p| p.can_take?(king) } if king
  end

  private

  def populate(x_coords, y_coords, color = :white)
    piece_order = [Rook, Knight, Bishop, Queen, King, Bishop, Knight, Rook]

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
