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
      create_piece_for_game(Pawn, 3, 4, @user2)
      expect(king.valid_move?(3, 4)).to be true
      expect(king.valid_moves.length).to be 8
    end
  end

  def create_piece_for_game(type, xpos, ypos, user = @user1)
    type.create(x_position: xpos,
                y_position: ypos,
                game_id: @game.id,
                player_id: user.id)
  end
end
