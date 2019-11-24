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

    populate(white_player_id, (0..7).to_a.reverse, [7, 6])
    populate(black_player_id, (0..7).to_a, [0, 1])
  end

  def piece_at(xpos, ypos)
    pieces.filter { |p| p.at_coord?(xpos, ypos) }.first
  end

  private

  def populate(player_id, x_coords, y_coords)
    piece_order = [Rook, Knight, Bishop, Queen, King, Bishop, Knight, Rook]

    x_coords.each do |x|
      pieces << piece_order[x].create(player_id: player_id,
                                      x_position: x,
                                      y_position: y_coords[0])
      pieces << Pawn.create(player_id: player_id,
                            x_position: x,
                            y_position: y_coords[1])
    end
  end
end
