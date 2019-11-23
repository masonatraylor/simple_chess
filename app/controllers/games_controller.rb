# frozen_string_literal: true

class GamesController < ApplicationController
  before_action :authenticate_user!, only: %w[new create update]

  def new
    @game = Game.new
  end

  def create
    @game = Game.new(game_params)
    current_user.games << @game
    if params[:color] == 'black'
      @game.black_player_id = current_user.id
    else
      @game.white_player_id = current_user.id
    end
    if @game.valid?
      @game.save
      return redirect_to @game
    end
    render :new
  end

  def update
    game = Game.find(params[:id])
    join(game, params[:join]) if params[:join]
    redirect_to game
  end

  def join(game, color = 'black')
    if color == 'black'
      game.black_player_id ||= current_user.id
    else
      game.white_player_id ||= current_user.id
    end
    game.save
  end

  def show
    @game = Game.find(params[:id])
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
