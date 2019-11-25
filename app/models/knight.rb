# frozen_string_literal: true

class Knight < Piece
  def valid_moves
    moves = jumps.map { |x, y| [x_position + x, y_position + y] }
    moves.reject { |x, y| invalid_move?(x, y) }
  end

  def jumps
    [[2, 1],
     [2, -1],
     [1, 2],
     [1, -2],
     [-1, 2],
     [-1, -2],
     [-2, 1],
     [-2, -1]]
  end
end
