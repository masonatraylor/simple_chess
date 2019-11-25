# frozen_string_literal: true

class Piece < ApplicationRecord
  include PiecesHelper
  belongs_to :game

  def at_coord?(xpos, ypos)
    x_position == xpos && y_position == ypos
  end

  def color
    white? ? 'white' : 'black'
  end

  def opposite_color
    white? ? 'black' : 'white'
  end

  def enemy_piece_at?(xpos, ypos)
    game.piece_at(xpos, ypos)&.color == opposite_color
  end

  def valid_move?(xpos, ypos)
    game.pieces.reload
    valid_moves.include?([xpos, ypos])
  end

  def valid_moves
    []
  end

  def move_to!(xpos, ypos)
    return false unless valid_move?(xpos, ypos)

    game.piece_at(xpos, ypos)&.delete
    update_attributes(x_position: xpos, y_position: ypos, moved: true)
  end

  def obstructed_by(xpos, ypos)
    return nil unless valid_coords_for_obstruction?(xpos, ypos)

    piece_obstructing(xpos, ypos)
  end

  private

  def valid_coords_for_obstruction?(xpos, ypos)
    x_diff = xpos - x_position
    y_diff = ypos - y_position
    x_diff.zero? || y_diff.zero? || x_diff.abs == y_diff.abs
  end

  def piece_obstructing(xpos, ypos)
    x_inc = inc(x_position, xpos)
    y_inc = inc(y_position, ypos)
    x = x_position + x_inc
    y = y_position + y_inc

    until x == xpos && y == ypos
      piece = game.piece_at(x, y)
      return piece if piece

      x += x_inc
      y += y_inc
    end

    nil
  end

  def inc(from, to)
    return 1 if from < to
    return -1 if from > to

    0
  end

  def invalid_move?(xpos, ypos)
    !on_board?(xpos, ypos) ||
      color == game.piece_at(xpos, ypos)&.color ||
      obstructed_by(xpos, ypos)
  end
end
