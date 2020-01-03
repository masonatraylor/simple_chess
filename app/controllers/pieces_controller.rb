# frozen_string_literal: true

class PiecesController < ApplicationController
  before_action :authenticate_user!, only: %w[show update]

  def update
    extract_update_params
    return if missing_pawn_promotion_type?

    move_piece if params[:ypos] && params[:xpos] && can_move?

    ActionCable.server.broadcast 'game_channel',
                                 reload: true

    redirect_to @piece.game
  end

  def extract_update_params
    @piece = Piece.find(params[:id])
    @xpos = params[:xpos].to_i
    @ypos = params[:ypos].to_i
    @promotion = params[:promotion]
  end

  def missing_pawn_promotion_type?
    !@promotion && @piece.type == 'Pawn' && [0, 7].include?(@ypos)
  end

  def can_move?
    unless current_user.controls_piece?(@piece)
      flash[:alert] << 'This is not your piece!'
    end
    flash[:alert] << "It is not this color's turn" unless @piece.my_turn?
    @piece.can_move?(current_user)
  end

  def move_piece
    if @promotion
      return unless @piece.valid_move?(@xpos, @ypos, @promotion)

      @piece.move_to!(@xpos, @ypos, @promotion)
    else
      return unless @piece.valid_move?(@xpos, @ypos)

      @piece.move_to!(@xpos, @ypos)
    end

    @piece.game.finish_turn
  end

  def highlight_moves
    @piece = Piece.find_by_id(params[:id])
  end
end
