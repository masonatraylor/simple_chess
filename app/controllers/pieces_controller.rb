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
    if params[:row] && params[:col]
    end
  end
end
