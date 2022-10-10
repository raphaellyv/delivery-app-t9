class AddEstimatedDeliveryDateToDetailedOrder < ActiveRecord::Migration[7.0]
  def change
    add_column :detailed_orders, :estimated_delivery_date, :datetime
  end
end
