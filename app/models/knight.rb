# frozen_string_literal: true

class Knight < Piece
  def valid_move?(xpos, ypos)
    ([(xpos - x_position).abs,
      (ypos - y_position).abs].sort == [1, 2]) &&
      super(xpos, ypos)
  end
end
