# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Bishop, type: :model do
  context 'is created' do
    it 'can be saved' do
      piece = Bishop.new
      game = build(:game)
      game.pieces << piece
      expect(piece.save).to be true
    end
  end
end
