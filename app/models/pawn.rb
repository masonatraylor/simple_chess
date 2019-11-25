# frozen_string_literal: true

class Pawn < Piece
  def valid_moves
    moves = step_move + jump_move + diagonal_moves
    moves.reject { |xpos, ypos| invalid_move?(xpos, ypos) }
  end

  def step_move
    return [] if enemy_piece_at?(x_position, y_position + dir)

    [[x_position, y_position + dir]]
  end

  def jump_move
    return [] if moved? || enemy_piece_at?(x_position, y_position + 2 * dir)

    [[x_position, y_position + 2 * dir]]
  end

  def diagonal_moves
    moves = []

    [-1, 1].each do |x_diff|
      if enemy_piece_at?(x_position + x_diff, y_position + dir)
        moves << [x_position + x_diff, y_position + dir]
      end
    end

    moves
  end

  def dir
    white? ? -1 : 1
  end
end
