# frozen_string_literal: true

class Game < ApplicationRecord
  has_many :pieces
  belongs_to :user
end
