# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Piece, type: :model do
  context 'obstruction checks' do
    it 'can detect horizontal obstructions' do
      game = build(:game)
      piece = create_piece_at_coord(game, 4, 4)

      expect(piece.obstructed_by(2, 4)).to be nil
      create_piece_at_coord(game, 3, 4)
      expect(piece.obstructed_by(2, 4)).not_to be nil

      expect(piece.obstructed_by(7, 4)).to be nil
      create_piece_at_coord(game, 6, 4)
      expect(piece.obstructed_by(7, 4)).not_to be nil
    end
  end

  it 'can detect horizontal obstructions' do
    game = build(:game)
    piece = create_piece_at_coord(game, 4, 4)

    expect(piece.obstructed_by(4, 6)).to be nil
    create_piece_at_coord(game, 4, 5)
    expect(piece.obstructed_by(4, 6)).not_to be nil

    expect(piece.obstructed_by(4, 1)).to be nil
    create_piece_at_coord(game, 4, 3)
    expect(piece.obstructed_by(4, 1)).not_to be nil
  end

  it 'can detect diagonal obstructions' do
    game = build(:game)
    piece = create_piece_at_coord(game, 4, 4)

    expect(piece.obstructed_by(7, 7)).to be nil
    create_piece_at_coord(game, 5, 5)
    expect(piece.obstructed_by(7, 7)).not_to be nil

    expect(piece.obstructed_by(1, 7)).to be nil
    create_piece_at_coord(game, 2, 6)
    expect(piece.obstructed_by(1, 7)).not_to be nil

    expect(piece.obstructed_by(0, 0)).to be nil
    create_piece_at_coord(game, 2, 2)
    expect(piece.obstructed_by(0, 0)).not_to be nil

    expect(piece.obstructed_by(7, 1)).to be nil
    create_piece_at_coord(game, 5, 3)
    expect(piece.obstructed_by(7, 1)).not_to be nil
  end

  it 'only checks intermediate coordinates' do
    game = build(:game)
    piece = create_piece_at_coord(game, 6, 2)

    expect(piece.obstructed_by(6, 2)).to be nil

    create_piece_at_coord(game, 7, 3)
    expect(piece.obstructed_by(7, 3)).to be nil

    create_piece_at_coord(game, 2, 2)
    expect(piece.obstructed_by(2, 2)).to be nil
  end

  it 'does not detect obstruction for invalid coordinates' do
    game = build(:game)
    (3..5).each do |row|
      (3..5).each do |col|
        create_piece_at_coord(game, row, col)
      end
    end

    piece = game.pieces.where(x_position:4, y_position:4).take

    expect(piece.obstructed_by(6, 1)).to be nil
    expect(piece.obstructed_by(6, 2)).not_to be nil
  end

  def create_piece_at_coord(game, xpos, ypos)
    piece = Piece.new(x_position: xpos, y_position: ypos)
    game.pieces << piece
    piece.save
    piece
  end
end
