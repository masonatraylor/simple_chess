# frozen_string_literal: true

class King < Piece
  def valid_moves
    x_positions = (x_position - 1..x_position + 1).to_a
    y_positions = (y_position - 1..y_position + 1).to_a

    x_positions.product(y_positions).reject { |x, y| invalid_move?(x, y) }
  end
end
