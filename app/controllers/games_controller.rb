# frozen_string_literal: true

class GamesController < ApplicationController
  def new
    @game = Game.new
  end

  def create
    game = Game.create(game_params)
    redirect_to game
  end

  def show
    @game = Game.find(params[:id])
  end

  def index
    @games = Game.available
  end

  private

  def game_params
    params.require(:game).permit(:name)
  end
end
