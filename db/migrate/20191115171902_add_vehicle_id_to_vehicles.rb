class AddVehicleIdToVehicles < ActiveRecord::Migration[6.0]
  def change
    add_column :vehicles, :vehicle_id, :string, unique: true, null: false
  end
end
