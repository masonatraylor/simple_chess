# frozen_string_literal: true

class King < Piece
  def valid_move?(xpos, ypos)
    !invalid_move?(xpos, ypos) && (
      valid_step_move?(xpos, ypos)
    )
  end

  def valid_step_move?(xpos, ypos)
    (xpos - x_position).abs <= 1 && (ypos - y_position).abs <= 1
  end
end
