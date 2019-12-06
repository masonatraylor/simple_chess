# frozen_string_literal: true

module PiecesHelper
  def flip_board?
    return false if current_user&.id != @game.black_player_id

    current_user&.id != @game.white_player_id
  end
end
