# frozen_string_literal: true

module PiecesHelper
  def on_board?(xpos, ypos)
    [xpos, ypos].min >= 0 && [xpos, ypos].max <= 7
  end
end
