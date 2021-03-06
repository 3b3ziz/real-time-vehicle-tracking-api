# frozen_string_literal: true

class Vehicle < ApplicationRecord
  has_many :locations
  validates :vehicle_id, uniqueness: true, presence: true
end
