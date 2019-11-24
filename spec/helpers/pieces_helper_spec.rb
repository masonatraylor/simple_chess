# frozen_string_literal: true

require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the PiecesHelper. For example:
#
# describe PiecesHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe PiecesHelper, type: :helper do
  context 'on board checks' do
    it 'should correctly determine if pieces are on board' do
      expect(helper.on_board?(-1, 0)).to eq(false)
      expect(helper.on_board?(5, -6)).to eq(false)
      expect(helper.on_board?(10, 6)).to eq(false)
      expect(helper.on_board?(3, 8)).to eq(false)
      expect(helper.on_board?(5, 3)).to eq(true)
      expect(helper.on_board?(2, 6)).to eq(true)
      expect(helper.on_board?(0, 0)).to eq(true)
      expect(helper.on_board?(7, 7)).to eq(true)
    end
  end
end
