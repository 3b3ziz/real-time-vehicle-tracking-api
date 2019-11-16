class Vehicle < ApplicationRecord
    has_many :locations, dependent: :delete_all
    validates :vehicle_id, uniqueness: true, presence: true
end
