# frozen_string_literal: true

require 'geocoder'

class VehiclesController < ApplicationController
  def create
    @vehicle_id = params[:id]
    @vehicle = Vehicle.new(vehicle_id: @vehicle_id)
    render json: {}, status: :no_content if @vehicle.save
  end

  def destroy
    @vehicle_id = params[:id]
    @vehicle = Vehicle.find_by_vehicle_id(@vehicle_id)
    if @vehicle&.destroy
      response = RestClient.delete "https://door2door-f9553.firebaseio.com/locations/#{@vehicle_id}.json"
    else
      render json: {}, status: :not_found
    end
  end

  def update_location
    @vehicle_id = params[:vehicle_id]
    @latitude = params[:lat]
    @longitude = params[:lng]
    @created_at = params[:at]
    @location_attrs = {
      lat: @latitude,
      lng: @longitude,
      at: @created_at
    }
    @vehicle = Vehicle.find_by_vehicle_id(@vehicle_id)
    @distance_to_center = Geocoder::Calculations.distance_between([@latitude, @longitude], Location::DOOR2DOOR_LOCATION_OFFICE, units: :km)
    has_locations = @vehicle.locations.length if @vehicle

    $redis.set(@vehicle_id, @created_at)

    # improvisation -- should remove location from view if out of boundries
    if (@distance_to_center > Location::CITY_BOUNDRY) && has_locations
      # very low priority
      # this request is to delete the location from firebase.
      # this is a bit inefficient since it might delete non-existent data from firebase.
      VehicleDeleteNotificationService.perform_async(@vehicle_id, @created_at, nil)
    end

    if @vehicle && (@distance_to_center <= Location::CITY_BOUNDRY)
      @location = @vehicle.locations.create(@location_attrs)
      if @location.save
        # highest priority
        VehicleUpdateNotificationService.perform_async(@vehicle_id, @created_at, @location_attrs.to_json)
      end
    end
  end
end
