# frozen_string_literal: true

class Queen < Piece
  def valid_move?(xpos, ypos)
    (valid_orthogonal_move?(xpos, ypos) ||
      valid_diagonal_move?(xpos, ypos)) &&
      super(xpos, ypos)
  end

  def valid_orthogonal_move?(xpos, ypos)
    xpos == x_position || ypos == y_position
  end

  def valid_diagonal_move?(xpos, ypos)
    xpos + ypos == x_position + y_position ||
      xpos - ypos == x_position - y_position
  end
end
