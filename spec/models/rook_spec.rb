# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Rook, type: :model do
  context 'rook is created' do
    it 'can be saved' do
      rook = Rook.new
      expect(rook.save).to be true
    end
  end
end
