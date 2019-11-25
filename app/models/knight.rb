# frozen_string_literal: true

class Knight < Piece
  def valid_move?(xpos, ypos)
    !invalid_move?(xpos, ypos) && (
      [(xpos - x_position).abs, (ypos - y_position).abs].sort == [1, 2]
    )
  end
end
