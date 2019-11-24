# frozen_string_literal: true

class Rook < Piece
  def valid_moves
    horizontal_moves = (0..7).to_a.product([y_position])
    vertical_moves = [x_position].product((0..7).to_a)
    moves = horizontal_moves + vertical_moves
    moves.reject { |x, y| invalid_move?(x, y) }
  end
end
