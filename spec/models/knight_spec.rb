# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Knight, type: :model do
  context 'knight is created' do
    it 'can be saved' do
      knight = Knight.new
      expect(knight.save).to be true
    end
  end
end
