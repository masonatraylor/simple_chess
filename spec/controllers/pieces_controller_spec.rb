# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PiecesController, type: :controller do
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

  context 'pawn promotion checks' do
    it 'should only allow white pawns to move onto the last row with promotions' do
      sign_in @user1
      piece = create_piece_for_game(Pawn, 4, 1)
      id = piece.id

      put :update, format: :xhr, params: { id: id, xpos: 4, ypos: 0 }
      expect(piece.reload.y_position).to eq(1)

      put :update, format: :xhr, params: { id: id, xpos: 4, ypos: 0, promotion: 'Queen' }
      piece = Piece.find(id)
      expect(piece.y_position).to eq(0)
      expect(piece.type == 'Queen')
    end

    it 'should not allow black pawns to move onto the last row without promoting' do
      sign_in @user2
      @game.change_turn!
      piece = create_piece_for_game(Pawn, 4, 6, :black)
      id = piece.id

      put :update, format: :xhr, params: { id: id, xpos: 4, ypos: 7 }
      expect(piece.reload.y_position).to eq(6)

      put :update, format: :xhr, params: { id: id, xpos: 4, ypos: 7, promotion: 'Rook' }
      piece = Piece.find(id)
      expect(piece.y_position).to eq(7)
      expect(piece.type).to eq('Rook')
    end

    it 'should not allow pawns to promote into Kings' do
      sign_in @user1
      piece = create_piece_for_game(Pawn, 4, 1)
      id = piece.id

      put :update, format: :xhr, params: { id: id, xpos: 4, ypos: 7, promotion: 'King' }
      piece = Piece.find(id)
      expect(piece.reload.y_position).to eq(1)
      expect(piece.type).to eq('Pawn')
    end

    it 'should not allow pawns to promote into Pawns' do
      sign_in @user1
      piece = create_piece_for_game(Pawn, 4, 1)
      id = piece.id

      put :update, format: :xhr, params: { id: id, xpos: 4, ypos: 7, promotion: 'Pawn' }
      piece = Piece.find(id)
      expect(piece.reload.y_position).to eq(1)
    end

    it 'should not allow pawns to promote outside of final row' do
      sign_in @user1
      piece = create_piece_for_game(Pawn, 4, 3)
      id = piece.id

      put :update, format: :xhr, params: { id: id, xpos: 4, ypos: 2, promotion: 'Rook' }
      piece = Piece.find(id)
      expect(piece.reload.y_position).to eq(3)
      expect(piece.type).to eq('Pawn')
    end

    it 'should enforce that promotions are correctly capitalized' do
      sign_in @user1
      piece = create_piece_for_game(Pawn, 4, 3)
      id = piece.id

      put :update, format: :xhr, params: { id: id, xpos: 4, ypos: 2, promotion: 'rook' }
      piece = Piece.find(id)
      expect(piece.reload.y_position).to eq(3)
      expect(piece.type).to eq('Pawn')
    end
  end

  def create_piece_for_game(type, xpos, ypos, color = :white)
    @game.pieces << type.create(x_position: xpos,
                                y_position: ypos,
                                white: color == :white)
    @game.pieces.last
  end
end
