# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Game, type: :model do
  context 'instantiation checks' do
    it 'can be instantiated' do
      game = build(:game)
      expect(game.valid?).to be true
    end
  end

  context 'check tests' do
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
    it 'can determine check' do
      king = create_piece_for_game(King, 4, 4)
      create_piece_for_game(Rook, 0, 4, :black)
      expect(@game.check?(:white)).to eq(true)
      king.move_to!(4, 5)
      expect(@game.check?(:white)).to eq(false)
    end
  end

  def create_piece_for_game(type, xpos, ypos, color = :white)
    @game.pieces << type.create(x_position: xpos,
                                y_position: ypos,
                                white: color == :white)
    @game.pieces.last
  end
end
