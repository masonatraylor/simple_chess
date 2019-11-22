require 'rails_helper'

RSpec.describe GamesController, :type => :controller do
  context 'initial commit context' do
    it 'will pass a test' do
      expect(true).to be true
    end
  end

  context 'initial commit context' do
    it 'will fail a test' do
      expect(true).to be false
    end
  end
end
