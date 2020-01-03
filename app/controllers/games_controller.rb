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
    return render :new unless @game.save

    @game.populate!(params[:type])
    redirect_to @game
  end

  def update
    game = Game.find(params[:id])
    join(game, params[:join]) if params[:join]
    forfeit(game) if params[:forfeit]
    redirect_to game
  end

  def join(game, color = 'black')
    if color == 'black'
      game.black_player_id = current_user.id unless game.black_player_id
    else
      game.white_player_id = current_user.id unless game.white_player_id
    end

    game.save
  end

  def forfeit(game)
    flash[:alert] = 'Unable to forfeit' unless game.forfeit(current_user.id)
  end

  def show
    @game = Game.find(params[:id])
    @movable_pieces = @game.pieces.filter { |p| p.can_move?(current_user) }
  end

  def index
    @games = Game.paginate(page: params[:all_games_page])
                 .order('updated_at DESC')
    @open_games = Game.available.paginate(page: params[:open_games_page])
                      .order('updated_at DESC')
  end

  private

  def game_params
    params.require(:game).permit(:name)
  end
end
