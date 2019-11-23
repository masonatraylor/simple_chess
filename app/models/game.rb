# frozen_string_literal: true

class Game < ApplicationRecord
  scope :available,
        -> { where('white_player_id is NULL or black_player_id is NULL') }
  has_many :pieces
  belongs_to :user

  validates :name, uniqueness: true, length: { minimum: 3, maximum: 60 }
end
