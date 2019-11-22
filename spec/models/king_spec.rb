# frozen_string_literal: true

require 'rails_helper'

RSpec.describe King, type: :model do
  context 'king is created' do
    it 'can be saved' do
      king = King.new
      expect(king.save).to be true
    end
  end
end
