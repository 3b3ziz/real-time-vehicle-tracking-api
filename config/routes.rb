# frozen_string_literal: true

require 'sidekiq/web'

Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :vehicles
  post '/vehicles/:vehicle_id/locations', action: :update_location, controller: 'vehicles'
  mount Sidekiq::Web => '/sidekiq'
end
