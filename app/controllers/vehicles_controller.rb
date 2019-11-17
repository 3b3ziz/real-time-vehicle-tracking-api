require 'rest-client'
require 'geocoder'

class VehiclesController < ApplicationController
  # TODO: change function name
  # rescue_from ActiveRecord::RecordNotUnique, with: :known_error

  def create
    @vehicle_id = vehicle_params[:id]
    @vehicle = Vehicle.new(vehicle_id: @vehicle_id)
  
    if @vehicle.save
      render json: {}, status: 200
    else
      render json: @vehicle.errors, status: :bad_request
    end
  end

  def destroy
    @vehicle_id = params[:id]
    @vehicle = Vehicle.find_by_vehicle_id(@vehicle_id)
    if @vehicle and @vehicle.destroy
      response = RestClient.delete "https://door2door-f9553.firebaseio.com/locations/#{@vehicle_id}.json"
      render json: {}, status: 200
    # TODO: handle if not found ..
    # else
    #   render json: @vehicle.errors, status: :bad_request
    end
  end

  def update_location
    @vehicle_id = params[:vehicle_id]
    @latitude = params[:lat]
    @longitude = params[:lng]
    @created_at = params[:at]
    @location_attrs = {
      lat: params[:lat],
      lng: params[:lng],
      at: params[:at]
    }
    @location_body = { 
      lat: @latitude,
      lng: @longitude,
      at: @created_at
    }.to_json
    @vehicle = Vehicle.find_by_vehicle_id(@vehicle_id)
    @distance_to_center = Geocoder::Calculations.distance_between([@latitude, @longitude], [52.53, 13.403], { units: :km })
    has_locations = @vehicle.locations.length if @vehicle
    #improvisation -- should remove location from view if out of boundries
    if @distance_to_center > 3.5 and has_locations
      # delete_response = Faraday.delete "https://door2door-f9553.firebaseio.com/locations/#{@vehicle_id}.json"
      delete_response = RestClient.delete "https://door2door-f9553.firebaseio.com/locations/#{@vehicle_id}.json"
    end

    if @vehicle and @distance_to_center <= 3.5
      @location = @vehicle.locations.create(@location_attrs)
      if @location.save
        update_response = RestClient.put "https://door2door-f9553.firebaseio.com/locations/#{@vehicle_id}.json", @location_body , { content_type: :json, accept: :json }
        # update_response = Faraday.put("https://door2door-f9553.firebaseio.com/locations/#{@vehicle_id}.json", @location_body, "Content-Type" => "application/json")
        render json: {}, status: 200
      else
        render json: {}, status: 200
        # render json: @location.errors, status: :bad_request
      end
    else
      render json: {}, status: 200
    end
  end
 
private
  def vehicle_params
    params.require(:vehicle).permit(:id)
  end
  # TODO: fix
  def location_params
    params.require([:vehicle_id, :lng, :lat, :at])
  end
  # def known_error(exception)
  #   @error = exception
  #   # Rails.logger.error "[JOBS] Exception #{exception.class}: #{exception.message}"
  #   render json: { error: "duplicate id" }, status: :bad_request
  # end
end
