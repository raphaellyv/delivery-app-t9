class AddDeliveryDateToDetailedOrder < ActiveRecord::Migration[7.0]
  def change
    add_column :detailed_orders, :delivery_date, :datetime
  end
end
