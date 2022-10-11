class CreateDelayedOrders < ActiveRecord::Migration[7.0]
  def change
    create_table :delayed_orders do |t|
      t.references :order, null: false, foreign_key: true
      t.string :cause_of_delay

      t.timestamps
    end
  end
end
