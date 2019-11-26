# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Game, type: :model do
  before(:all) do
    @user1 = create(:user)
    @user2 = create(:user)
  end
  before(:each) do
    @game = create(:game)
    @game.white_player_id = @user1.id
    @game.black_player_id = @user2.id
    @game.save
  end

  context 'check? tests' do
    it 'can determine check' do
      king = create_piece_for_game(King, 4, 4)
      create_piece_for_game(Rook, 0, 4, :black)
      expect(@game.check?(:white)).to eq(true)
      king.move_to!(4, 5)
      expect(@game.check?(:white)).to eq(false)
    end
  end

  context 'finish_turn tests' do
    it "should change turn when there's no checkmate" do
      create_piece_for_game(King, 4, 4)
      create_piece_for_game(King, 0, 4, :black)

      expect(@game.turn_color).to eq(:white)
      expect(@game.check?(:white)).to eq(false)

      @game.finish_turn
      expect(@game.turn_color).to eq(:black)
    end
    it 'should record a winner when there is checkmate' do
      create_piece_for_game(King, 2, 4)
      create_piece_for_game(Rook, 0, 0)
      create_piece_for_game(King, 0, 4, :black)

      @game.finish_turn
      expect(@game.white_won?).to eq(true)
    end
    it 'record a stalemate when next player has no moves' do
      create_piece_for_game(King, 0, 2)
      create_piece_for_game(Rook, 1, 7)
      create_piece_for_game(King, 0, 0, :black)

      @game.finish_turn
      expect(@game.stalemate?).to eq(true)
    end
  end

  def create_piece_for_game(type, xpos, ypos, color = :white)
    @game.pieces << type.create(x_position: xpos,
                                y_position: ypos,
                                white: color == :white)
    @game.pieces.last
  end
end
