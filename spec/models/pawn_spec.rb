# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Pawn, type: :model do
  context 'pawn is created' do
    it 'can be saved' do
      pawn = Pawn.new
      expect(pawn.save).to be true
    end
  end
end
