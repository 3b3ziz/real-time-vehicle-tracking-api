require 'rest-client'

class Firebase
  include Sidekiq::Worker

  def perform(vehicle_id, location_body, method)
    if method == "put"
      update_response = RestClient.put "https://door2door-f9553.firebaseio.com/locations/#{vehicle_id}.json", location_body , { content_type: :json, accept: :json }
      # puts 'update_response ', update_response.code
    elsif method == "delete"
      delete_response = RestClient.delete "https://door2door-f9553.firebaseio.com/locations/#{vehicle_id}.json"
      # puts 'delete_response ', delete_response.code
    end
  end
end