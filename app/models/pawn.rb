# frozen_string_literal: true

class Pawn < Piece
  def valid_move?(xpos, ypos)
    (valid_step_move?(xpos, ypos) ||
      valid_jump_move?(xpos, ypos) ||
      valid_diagonal_move?(xpos, ypos)) &&
      super(xpos, ypos)
  end

  def valid_step_move?(xpos, ypos)
    xpos == x_position &&
      ypos == y_position + dir &&
      !enemy_piece_at?(x_position, y_position + dir)
  end

  def valid_jump_move?(xpos, ypos)
    !moved? &&
      xpos == x_position &&
      ypos == y_position + 2 * dir &&
      !enemy_piece_at?(x_position, y_position + 2 * dir)
  end

  def valid_diagonal_move?(xpos, ypos)
    (xpos - x_position).abs == 1 &&
      ypos == y_position + dir &&
      enemy_piece_at?(xpos, ypos)
  end

  def dir
    white? ? -1 : 1
  end
end
