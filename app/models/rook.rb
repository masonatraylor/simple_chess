# frozen_string_literal: true

class Rook < Piece
  def valid_move?(xpos, ypos)
    !invalid_move?(xpos, ypos) && (
      xpos == x_position ||
      ypos == y_position)
  end
end
