class DetailedOrder < ApplicationRecord
  belongs_to :order
  belongs_to :shipping_option
  belongs_to :vehicle

  validates :estimated_delivery_date, :total_price, presence: true
end
