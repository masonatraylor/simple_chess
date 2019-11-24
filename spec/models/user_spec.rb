# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  context 'instantiation checks' do
    it 'can be instantiated' do
      user = build(:user1)
      expect(user.valid?).to be true
    end
  end
end
