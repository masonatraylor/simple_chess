# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Game, type: :model do
  context 'instantiation checks' do
    it 'can be instantiated' do
      game = build(:game)
      expect(game.valid?).to be true
    end
  end
end
