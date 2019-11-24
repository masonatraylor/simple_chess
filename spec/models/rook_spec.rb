# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Rook, type: :model do
  context 'is created' do
    it 'should be able to be saved' do
      piece = Rook.new
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
    it 'should be able to move horizontally' do
      rook = create_piece_for_game(Rook, 3, 3)
      expect((0..2).all? { |i| rook.valid_move?(i, 3) }).to eq(true)
      expect((4..7).all? { |i| rook.valid_move?(i, 3) }).to eq(true)
    end
    it 'should be able to move vertically' do
      rook = create_piece_for_game(Rook, 3, 3)
      expect((0..2).all? { |i| rook.valid_move?(3, i) }).to eq(true)
      expect((4..7).all? { |i| rook.valid_move?(3, i) }).to eq(true)
    end
    it 'should be obstructed by other pieces' do
      rook = create_piece_for_game(Rook, 3, 3)
      create_piece_for_game(Rook, 5, 3)
      expect(rook.valid_move?(5, 3)).to eq(false)
      expect(rook.valid_move?(8, 3)).to eq(false)
    end
    it 'should be able to take opponent pieces' do
      rook = create_piece_for_game(Rook, 3, 3)
      create_piece_for_game(Rook, 1, 3, @user2)
      expect(rook.valid_move?(1, 3)).to eq(true)
    end
  end

  def create_piece_for_game(type, xpos, ypos, user = @user1)
    type.create(x_position: xpos,
                y_position: ypos,
                game_id: @game.id,
                player_id: user.id)
  end
end
