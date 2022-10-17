class ShippingOption < ApplicationRecord
  has_many :deadlines
  has_many :detailed_orders
  has_many :distance_fees
  has_many :orders, through: :detailed_orders
  has_many :prices
  has_many :vehicles

  enum :status, { disabled: 10, enabled: 20 }, default: :enabled
  
  validates :delivery_fee, :max_distance, :min_distance, :min_weight, :max_weight, :name, presence: true
  validates :delivery_fee, :min_distance, :min_weight, numericality: { greater_than: 0 }
  validates :max_distance, comparison: { greater_than: :min_distance }
  validates :max_weight, comparison: { greater_than: :min_weight }
  validates :name, uniqueness: true

  def generate_quotation_for(order)
    price = self.prices.where(["min_weight <= ? and max_weight >= ?", order.weight, order.weight]).first
    deadline = self.deadlines.where(["min_distance <= ? and max_distance >= ?", order.distance, order.distance]).first
    distance_fee = self.distance_fees.where(["min_distance <= ? and max_distance >= ?", order.distance, order.distance]).first

    total_amount = (price.price_per_km * order.distance) + delivery_fee + distance_fee.fee

    {shipping_option: self, order: order, deadline: deadline.deadline, price: total_amount}
  end
end
