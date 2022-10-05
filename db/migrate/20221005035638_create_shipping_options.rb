class CreateShippingOptions < ActiveRecord::Migration[7.0]
  def change
    create_table :shipping_options do |t|
      t.string :name
      t.integer :min_distance
      t.integer :max_distance
      t.integer :min_weight
      t.integer :max_weight
      t.decimal :delivery_fee
      t.integer :status

      t.timestamps
    end
  end
end
