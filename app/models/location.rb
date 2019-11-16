class Location < ApplicationRecord
    belongs_to :vehicle
    validates :vehicle_id, :lat, :lng, :at, presence: true
end
