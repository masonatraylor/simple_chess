# frozen_string_literal: true

module GamesHelper
  def player_or_join(game, color)
    player_id = color == 'black' ? game.black_player_id : game.white_player_id
    return User.find(player_id).email if player_id

    link_to('join', game_path(game, join: color), method: :put)
  end

  def piece_color(piece)
    return 'black' if piece.player_id == @game.black_player_id

    'white' if piece.player_id == @game.white_player_id
  end
end
