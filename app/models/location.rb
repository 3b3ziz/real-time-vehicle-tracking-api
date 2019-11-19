class Location < ApplicationRecord
    belongs_to :vehicle
    validates :vehicle_id, :lat, :lng, :at, presence: true

    DOOR2DOOR_LOCATION_OFFICE = [52.53, 13.403]
    CITY_BOUNDRY = 3.5
end
