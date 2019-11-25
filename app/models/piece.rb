# frozen_string_literal: true

class Piece < ApplicationRecord
  include PiecesHelper
  belongs_to :game

  def at_coord?(xpos, ypos)
    x_position == xpos && y_position == ypos
  end

  def color
    white? ? :white : :black
  end

  def opposite_color
    white? ? :black : :white
  end

  def enemy_piece_at?(xpos, ypos)
    game.piece_at(xpos, ypos)&.color == opposite_color
  end

  def valid_move?(xpos, ypos)
    false
  end

  def valid_moves
    all_coords = (0..7).to_a.product((0..7).to_a)
    all_coords.filter{ |x, y| valid_move?(x, y) }
  end

  def move_to!(xpos, ypos)
    game.piece_at(xpos,
                  ypos)&.update_attributes(x_position: nil, y_position: nil)
    update_attributes(x_position: xpos, y_position: ypos, moved: true)
    game.pieces.reload
  end

  def obstructed?(xpos, ypos)
    return false unless valid_coords_for_obstruction?(xpos, ypos)

    x_inc = inc(xpos, x_position)
    y_inc = inc(ypos, y_position)

    # Only check squares between the two endpoints
    until xpos + x_inc == x_position && ypos + y_inc == y_position
      xpos += x_inc
      ypos += y_inc

      return true if game.piece_at(xpos, ypos)
    end

    false
  end

  def can_take?(piece)
    valid_move?(piece.x_position, piece.y_position)
  end

  def on_board?
    Piece.on_board?(x_position, y_position)
  end

  def self.on_board?(xpos, ypos)
    return false unless xpos && ypos

    [xpos, ypos].min >= 0 && [xpos, ypos].max <= 7
  end

  private

  def valid_coords_for_obstruction?(xpos, ypos)
    x_diff = xpos - x_position
    y_diff = ypos - y_position
    x_diff.zero? || y_diff.zero? || x_diff.abs == y_diff.abs
  end

  def inc(from, to)
    return 1 if from < to
    return -1 if from > to

    0
  end

  def invalid_move?(xpos, ypos)
    !Piece.on_board?(xpos, ypos) ||
      color == game.piece_at(xpos, ypos)&.color ||
      obstructed?(xpos, ypos)
  end
end
