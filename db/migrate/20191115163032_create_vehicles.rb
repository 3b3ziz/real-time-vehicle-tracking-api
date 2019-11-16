class CreateVehicles < ActiveRecord::Migration[6.0]
  def change
    create_table :vehicles do |t|

      t.timestamps
    end
  end
end
