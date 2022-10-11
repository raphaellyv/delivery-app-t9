class RemoveCauseOfDelayFromDetailedOrder < ActiveRecord::Migration[7.0]
  def change
    remove_column :detailed_orders, :cause_of_delay, :string
  end
end
