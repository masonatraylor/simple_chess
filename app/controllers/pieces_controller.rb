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
    move_piece if params[:row] && params[:col]

    redirect_to @piece.game
  end

  def move_piece
    col = params[:col].to_i
    row = params[:row].to_i
    return @piece.move_to!(col, row) if @piece.valid_move?(col, row)

    flash[:alert] = 'Invalid move!' unless @piece.at_coord?(col, row)
  end
end
