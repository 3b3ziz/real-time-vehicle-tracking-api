# frozen_string_literal: true

require 'rest-client'

class VehicleDeleteNotificationService
  include Sidekiq::Worker
  sidekiq_options queue: 'low'

  def perform(vehicle_id, at, _location_body = nil)
    created_at = $redis.get(vehicle_id)

    # Handling if one location update scheduled before a newer one
    # by saving the last location timestamp in redis and comparing it with
    # the location timestamp.

    if created_at.nil? || created_at <= at
      delete_response = RestClient.delete "https://door2door-f9553.firebaseio.com/locations/#{vehicle_id}.json"
      # puts 'delete_response ', delete_response.code
    end
  end
end
