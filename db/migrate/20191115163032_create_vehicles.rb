# frozen_string_literal: true

class CreateVehicles < ActiveRecord::Migration[6.0]
  def change
    create_table :vehicles, &:timestamps
  end
end
