# frozen_string_literal: true

class PiecesController < ApplicationController
  before_action :authenticate_user!, only: %w[show update]

  def show
    @piece = Piece.find(params[:id])
    @game = @piece.game
    @pieces = @game.pieces
    @moves = @piece.valid_moves
  end

  def update
    @piece = Piece.find(params[:id])

    move_piece if params[:ypos] && params[:xpos] && can_move
    redirect_to @piece.game
  end

  def can_move
    if current_user.id != @piece.player_id
      flash[:alert] = "That's not your piece!"
      return false
    elsif @piece.game.turn_color != @piece.color
      flash[:alert] = "It's not your turn!"
      return false
    end

    true
  end

  def move_piece
    xpos = params[:xpos].to_i
    ypos = params[:ypos].to_i

    if @piece.valid_move?(xpos, ypos)
      @piece.move_to!(xpos, ypos)
      @piece.game.finish_turn
    end

    flash[:alert] = 'Invalid move!' unless @piece.at_coord?(xpos, ypos)
  end
end
