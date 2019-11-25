# frozen_string_literal: true

require 'rails_helper'

RSpec.describe King, type: :model do
  context 'is created' do
    it 'should be able to be saved' do
      piece = King.new
      game = build(:game)
      game.pieces << piece
      expect(piece.save).to be true
    end
  end

  context 'movement checks' do
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

    it 'should be able to move 8 surrounding squares' do
      king = create_piece_for_game(King, 4, 4)
      expect(king.valid_moves.length).to be 8
    end
    it 'should not move off the board' do
      king = create_piece_for_game(King, 0, 0)
      expect(king.valid_moves.length).to be 3
    end
    it 'should not move onto friendly pieces' do
      king = create_piece_for_game(King, 3, 3)
      create_piece_for_game(Pawn, 3, 4)
      expect(king.valid_move?(3, 4)).to be false
      expect(king.valid_moves.length).to be 7
    end
    it 'should be able to move onto enemy pieces' do
      king = create_piece_for_game(King, 3, 3)
      create_piece_for_game(Pawn, 3, 4, :black)
      expect(king.valid_move?(3, 4)).to be true
      expect(king.valid_moves.length).to be 8
    end
    it 'should be able to castle' do
      king = create_piece_for_game(King, 4, 0)
      rook = create_piece_for_game(Rook, 0, 0)
      expect(king.valid_move?(1, 0)).to eq(true)
      king.move_to!(1, 0)
      expect(rook.reload.at_coord?(2, 0)).to eq(true)
    end
    it 'should not be able to castle when in check' do
      king = create_piece_for_game(King, 4, 0)
      create_piece_for_game(Rook, 0, 0)
      create_piece_for_game(Queen, 4, 6, :black)
      expect(king.valid_move?(1, 0)).to eq(false)
    end
    it 'should not be able to castle through check' do
      king = create_piece_for_game(King, 4, 0)
      create_piece_for_game(Rook, 0, 0)
      create_piece_for_game(Queen, 3, 6, :black)
      expect(king.valid_move?(1, 0)).to eq(false)
    end
    it 'should not be able to castle into check' do
      king = create_piece_for_game(King, 4, 0)
      create_piece_for_game(Rook, 0, 0)
      create_piece_for_game(Queen, 1, 6, :black)
      expect(king.valid_move?(1, 0)).to eq(false)
    end
    it 'should not be able to castle through pieces' do
      king = create_piece_for_game(King, 4, 0)
      create_piece_for_game(Rook, 0, 0)
      create_piece_for_game(Queen, 3, 0)
      expect(king.valid_move?(1, 0)).to eq(false)
    end
  end

  def create_piece_for_game(type, xpos, ypos, color = :white)
    @game.pieces << type.create(x_position: xpos,
                                y_position: ypos,
                                white: color == :white)
    @game.pieces.last
  end
end
