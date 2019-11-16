require 'rest-client'

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
    if @vehicle.destroy
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
    @vehicle = Vehicle.find_by_vehicle_id(@vehicle_id)
    if @vehicle
      @location = @vehicle.locations.create(@location_attrs)
      if @location.save
        response = RestClient.put "https://door2door-f9553.firebaseio.com/locations/#{@vehicle_id}.json", { 
          lat: @latitude,
          lng: @longitude,
          at: @created_at
        }.to_json, { content_type: :json, accept: :json }
        render json: {}, status: 200
      else
        render json: @location.errors, status: :bad_request
      end
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
