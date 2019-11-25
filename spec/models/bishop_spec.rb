# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Bishop, type: :model do
  context 'is created' do
    it 'should be able to be saved' do
      piece = Bishop.new
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
    it 'should be able to move diagonally' do
      bishop = create_piece_for_game(Bishop, 4, 4)
      expect(bishop.valid_move?(3, 3)).to eq(true)
      expect(bishop.valid_move?(7, 7)).to eq(true)
      expect(bishop.valid_move?(1, 7)).to eq(true)
      expect(bishop.valid_move?(7, 1)).to eq(true)
    end
    it 'should be able to be obstructed' do
      bishop = create_piece_for_game(Bishop, 4, 4)
      expect(bishop.valid_move?(7, 7)).to eq(true)
      create_piece_for_game(Bishop, 5, 5)
      expect(bishop.valid_move?(7, 7)).to eq(false)
    end
    it 'should be able to take enemy pieces' do
      bishop = create_piece_for_game(Bishop, 4, 4)
      create_piece_for_game(Rook, 2, 2, :black)
      expect(bishop.valid_move?(2, 2)).to eq(true)
    end
  end

  def create_piece_for_game(type, xpos, ypos, color = :white)
    @game.pieces << type.create(x_position: xpos,
                                y_position: ypos,
                                white: color == :white)
    @game.pieces.last
  end
end
