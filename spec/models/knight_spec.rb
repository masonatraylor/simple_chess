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
end
