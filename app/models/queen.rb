# frozen_string_literal: true

class Queen < Piece
  def valid_moves
    moves = horizontal_moves + vertical_moves + diagonal_moves
    moves.reject { |x, y| invalid_move?(x, y) }
  end

  def horizontal_moves
    (0..7).to_a.product([y_position])
  end

  def vertical_moves
    [x_position].product((0..7).to_a)
  end

  def diagonal_moves
    moves = []
    directions = [1, -1].product([1, -1])

    (0..7).each do |i|
      directions.each do |x_dir, y_dir|
        moves << [x_position + x_dir * i, y_position + y_dir * i]
      end
    end

    moves
  end
end
