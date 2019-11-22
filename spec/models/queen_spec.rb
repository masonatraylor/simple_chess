# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Queen, type: :model do
  context 'queen is created' do
    it 'can be saved' do
      queen = Queen.new
      expect(queen.save).to be true
    end
  end
end
