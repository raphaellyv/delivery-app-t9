class AddTotalPriceToDetailedOrder < ActiveRecord::Migration[7.0]
  def change
    add_column :detailed_orders, :total_price, :decimal
  end
end
