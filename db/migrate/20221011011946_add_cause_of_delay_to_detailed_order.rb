class AddCauseOfDelayToDetailedOrder < ActiveRecord::Migration[7.0]
  def change
    add_column :detailed_orders, :cause_of_delay, :string
  end
end
