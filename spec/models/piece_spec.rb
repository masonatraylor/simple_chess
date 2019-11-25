# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Piece, type: :model do
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

  context 'obstruction checks' do
    it 'should detect horizontal obstructions' do
      piece = create_piece_for_game(Piece, 4, 4)

      expect(piece.obstructed?(2, 4)).to eq(false)
      create_piece_for_game(Piece, 3, 4)
      expect(piece.obstructed?(2, 4)).to eq(true)

      expect(piece.obstructed?(7, 4)).to eq(false)
      create_piece_for_game(Piece, 6, 4)
      expect(piece.obstructed?(7, 4)).to eq(true)
    end

    it 'should detect vertical obstructions' do
      piece = create_piece_for_game(Piece, 4, 4)

      expect(piece.obstructed?(4, 6)).to eq(false)
      create_piece_for_game(Piece, 4, 5)
      expect(piece.obstructed?(4, 6)).to eq(true)

      expect(piece.obstructed?(4, 1)).to eq(false)
      create_piece_for_game(Piece, 4, 3)
      expect(piece.obstructed?(4, 1)).to eq(true)
    end

    it 'should detect diagonal obstructions' do
      piece = create_piece_for_game(Piece, 4, 4)

      expect(piece.obstructed?(7, 7)).to eq(false)
      create_piece_for_game(Piece, 5, 5)
      expect(piece.obstructed?(7, 7)).to eq(true)

      expect(piece.obstructed?(1, 7)).to eq(false)
      create_piece_for_game(Piece, 2, 6)
      expect(piece.obstructed?(1, 7)).to eq(true)

      expect(piece.obstructed?(0, 0)).to eq(false)
      create_piece_for_game(Piece, 2, 2)
      expect(piece.obstructed?(0, 0)).to eq(true)

      expect(piece.obstructed?(7, 1)).to eq(false)
      create_piece_for_game(Piece, 5, 3)
      expect(piece.obstructed?(7, 1)).to eq(true)
    end

    it 'should only check intermediate coordinates' do
      piece = create_piece_for_game(Piece, 6, 2)

      expect(piece.obstructed?(6, 2)).to eq(false)

      create_piece_for_game(Piece, 7, 3)
      expect(piece.obstructed?(7, 3)).to eq(false)

      create_piece_for_game(Piece, 2, 2)
      expect(piece.obstructed?(2, 2)).to eq(false)
    end

    it 'should not detect obstruction for invalid coordinates' do
      (3..5).each do |row|
        (3..5).each do |col|
          create_piece_for_game(Piece, row, col)
        end
      end

      piece = @game.piece_at(4, 4)

      expect(piece.obstructed?(6, 1)).to eq(false)
      expect(piece.obstructed?(6, 2)).to eq(true)
    end
  end

  context 'color tests' do
    it 'should correctly determine color' do
      piece = Piece.new(white: true)
      expect(piece.color).to eq(:white)

      piece = Piece.new(white: false)
      expect(piece.color).to eq(:black)
    end
  end

  context 'on board checks' do
    it 'should correctly determine if pieces are on board' do
      expect(Piece.on_board?(-1, 0)).to eq(false)
      expect(Piece.on_board?(5, -6)).to eq(false)
      expect(Piece.on_board?(10, 6)).to eq(false)
      expect(Piece.on_board?(3, 8)).to eq(false)
      expect(Piece.on_board?(5, 3)).to eq(true)
      expect(Piece.on_board?(2, 6)).to eq(true)
      expect(Piece.on_board?(0, 0)).to eq(true)
      expect(Piece.on_board?(7, 7)).to eq(true)
    end
  end

  def create_piece_for_game(type, xpos, ypos, color = :white)
    @game.pieces << type.create(x_position: xpos,
                                y_position: ypos,
                                white: color == :white)
    @game.pieces.last
  end
end
