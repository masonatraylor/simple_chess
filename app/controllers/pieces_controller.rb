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
    move_piece if params[:row] && params[:col] && can_move

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
    col = params[:col].to_i
    row = params[:row].to_i
    if @piece.valid_move?(col, row)
      @piece.move_to!(col, row) 
      @piece.game.finish_turn
    end

    flash[:alert] = 'Invalid move!' unless @piece.at_coord?(col, row)
  end
end
