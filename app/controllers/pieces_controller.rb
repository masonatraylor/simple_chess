# frozen_string_literal: true

class PiecesController < ApplicationController
  before_action :authenticate_user!, only: %w[show update]

  def update
    @piece = Piece.find(params[:id])

    move_piece if params[:ypos] && params[:xpos] && can_move?
    redirect_to @piece.game
  end

  def can_move?
    flash[:alert] << 'This is not your piece!' unless current_user.controls_piece?(@piece)
    flash[:alert] << "It is not this color's turn" unless @piece.my_turn?
    @piece.can_move?(current_user)
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
