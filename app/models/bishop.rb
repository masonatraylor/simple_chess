# frozen_string_literal: true

class Bishop < Piece
  def valid_moves
    moves = []
    directions = [1, -1].product([1, -1])

    (0..7).each do |i|
      directions.each do |x_dir, y_dir|
        moves << [x_position + x_dir * i, y_position + y_dir * i]
      end
    end

    moves.reject { |x, y| invalid_move?(x, y) }
  end
end
