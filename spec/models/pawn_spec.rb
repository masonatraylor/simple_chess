# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Pawn, type: :model do
  context 'is created' do
    it 'should be able to be saved' do
      piece = Pawn.new
      game = build(:game)
      game.pieces << piece
      expect(piece.save).to be true
    end
  end

  context 'movement tests' do
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
    it 'should only be able to jump before being moved' do
      pawn = create_piece_for_game(Pawn, 2, 6)
      expect(pawn.valid_move?(2, 4)).to eq(true)
      pawn.move_to!(2, 4)
      expect(pawn.valid_move?(2, 2)).to eq(false)
    end
    it 'should only be able to take diagonally' do
      white_pawn = create_piece_for_game(Pawn, 2, 6)
      create_piece_for_game(Pawn, 2, 5, :black)
      expect(white_pawn.valid_move?(2, 5)).to eq(false)
      expect(white_pawn.valid_move?(3, 5)).to eq(false)
      create_piece_for_game(Pawn, 1, 5, :black)
      expect(white_pawn.valid_move?(1, 5)).to eq(true)
    end
    it 'should move in the right direction' do
      white_pawn = create_piece_for_game(Pawn, 2, 6)
      expect(white_pawn.valid_move?(2, 5)).to eq(true)
      expect(white_pawn.valid_move?(2, 7)).to eq(false)

      black_pawn = create_piece_for_game(Pawn, 3, 3, @user2)
      expect(black_pawn.valid_move?(3, 4)).to eq(true)
      expect(black_pawn.valid_move?(3, 2)).to eq(false)
    end
  end

  def create_piece_for_game(type, xpos, ypos, color = :white)
    type.create(x_position: xpos,
                y_position: ypos,
                game_id: @game.id,
                white: color == :white)
  end
end
