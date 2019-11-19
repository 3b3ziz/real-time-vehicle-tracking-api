require 'rest-client'

class VehicleUpdateNotificationService
  include Sidekiq::Worker
  sidekiq_options queue: 'critical'

  def perform(vehicle_id, at, location_body = nil)
    created_at = $redis.get(vehicle_id)
    
    # Handling if one location update scheduled before a newer one
    # by saving the last location timestamp in redis and comparing it with
    # the location timestamp.

    if(created_at.nil? || created_at <= at)
      update_response = RestClient.put "https://door2door-f9553.firebaseio.com/locations/#{vehicle_id}.json", location_body , { content_type: :json, accept: :json }
      # puts 'update_response ', update_response.code
    end
  end
end