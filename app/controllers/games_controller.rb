# frozen_string_literal: true

class GamesController < ApplicationController
  before_action :authenticate_user!, only: %w[new create update]

  def new
    @game = Game.new
  end

  def create
    @game = Game.new(game_params)
    current_user.games << @game
    join(@game, params[:join])
    return redirect_to @game if @game.save

    render :new
  end

  def update
    game = Game.find(params[:id])
    join(game, params[:join]) if params[:join]
    redirect_to game
  end

  def join(game, color = 'black')
    if color == 'black'
      return if game.black_player_id

      game.black_player_id = current_user.id
    else
      return if game.white_player_id

      game.white_player_id = current_user.id
    end
    
    game.populate! if game.white_player_id && game.black_player_id
    
    game.save
  end

  def show
    @game = Game.find(params[:id])
    @pieces = @game.pieces
  end

  def index
    @games = Game.all
    @open_games = Game.available
  end

  private

  def game_params
    params.require(:game).permit(:name)
  end
end
