# frozen_string_literal: true

class Piece < ApplicationRecord
  belongs_to :game

  def obstructed_by(xpos, ypos)
    return nil unless valid_coords?(xpos, ypos)

    piece_blocking(xpos, ypos)
  end

  private

  def valid_coords?(xpos, ypos)
    x_diff = xpos - x_position
    y_diff = ypos - y_position
    x_diff.zero? || y_diff.zero? || x_diff.abs == y_diff.abs
  end

  def piece_blocking(xpos, ypos)
    x_inc = inc(x_position, xpos)
    y_inc = inc(y_position, ypos)
    x = x_position + x_inc
    y = y_position + y_inc
    until x == xpos && y == ypos
      piece = game.pieces.where(x_position: x, y_position: y).take
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
end
