# frozen_string_literal: true

class Bishop < Piece
  def valid_move?(xpos, ypos)
    (xpos + ypos == x_position + y_position ||
      xpos - ypos == x_position - y_position) &&
      super(xpos, ypos)
  end
end
