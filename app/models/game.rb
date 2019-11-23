# frozen_string_literal: true

class Game < ApplicationRecord
  scope :available,
        -> { where('white_player_id is NULL or black_player_id is NULL') }
  has_many :pieces
  belongs_to :user
end
