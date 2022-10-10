class AddVehicleToDetailedOrder < ActiveRecord::Migration[7.0]
  def change
    add_reference :detailed_orders, :vehicle, null: false, foreign_key: true
  end
end
