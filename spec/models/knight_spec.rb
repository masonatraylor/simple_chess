# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Knight, type: :model do
  context 'is created' do
    it 'should be able to be saved' do
      piece = Knight.new
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
    it 'should be able to move in an L' do
      knight = create_piece_for_game(Knight, 4, 4)
      expect(knight.valid_move?(2, 3)).to eq(true)
      expect(knight.valid_move?(3, 2)).to eq(true)
      expect(knight.valid_move?(2, 5)).to eq(true)
      expect(knight.valid_move?(5, 2)).to eq(true)
      expect(knight.valid_move?(3, 6)).to eq(true)
      expect(knight.valid_move?(6, 3)).to eq(true)
      expect(knight.valid_move?(5, 6)).to eq(true)
      expect(knight.valid_move?(6, 5)).to eq(true)
    end
    it 'should not be able to be obstructed' do
      knight = create_piece_for_game(Knight, 4, 4)
      (0..7).each { |i| create_piece_for_game(Pawn, i, 5) }
      expect(knight.valid_move?(5, 6)).to eq(true)
    end
    it 'should be able to take enemy pieces' do
      knight = create_piece_for_game(Knight, 4, 4)
      create_piece_for_game(Rook, 3, 2, :black)
      expect(knight.valid_move?(3, 2)).to eq(true)
    end
  end

  def create_piece_for_game(type, xpos, ypos, color = :white)
    type.create(x_position: xpos,
                y_position: ypos,
                game_id: @game.id,
                white: color == :white)
  end
end
