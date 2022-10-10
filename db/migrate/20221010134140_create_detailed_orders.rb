class CreateDetailedOrders < ActiveRecord::Migration[7.0]
  def change
    create_table :detailed_orders do |t|
      t.references :order, null: false, foreign_key: true
      t.references :shipping_option, null: false, foreign_key: true

      t.timestamps
    end
  end
end
