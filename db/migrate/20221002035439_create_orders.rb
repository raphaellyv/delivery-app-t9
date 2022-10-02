class CreateOrders < ActiveRecord::Migration[7.0]
  def change
    create_table :orders do |t|
      t.string :delivery_address
      t.string :delivery_city
      t.string :delivery_state
      t.string :delivery_postal_code
      t.string :recipient
      t.string :recipient_cpf
      t.string :recipient_email
      t.string :recipient_phone_number
      t.string :pick_up_address
      t.string :pick_up_city
      t.string :pick_up_state
      t.string :pick_up_postal_code
      t.string :sku
      t.integer :height
      t.integer :width
      t.integer :length
      t.integer :weight
      t.integer :distance

      t.timestamps
    end
  end
end
