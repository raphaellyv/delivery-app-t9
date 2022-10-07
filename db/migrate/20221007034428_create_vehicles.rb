class CreateVehicles < ActiveRecord::Migration[7.0]
  def change
    create_table :vehicles do |t|
      t.references :shipping_option, null: false, foreign_key: true
      t.string :license_plate
      t.string :brand
      t.string :car_model
      t.string :manufacture_year
      t.integer :max_weight
      t.integer :status

      t.timestamps
    end
  end
end
