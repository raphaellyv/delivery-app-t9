class ShippingOption < ApplicationRecord
  has_many :deadlines
  has_many :detailed_orders
  has_many :distance_fees
  has_many :orders, through: :detailed_orders
  has_many :prices
  has_many :vehicles

  enum :status, { disabled: 10, enabled: 20 }, default: :enabled
  
  validates :delivery_fee, :max_distance, :min_distance, :min_weight, :max_weight, :name, presence: true
  validates :delivery_fee, :max_distance, :min_distance, :max_weight, :min_weight, numericality: { greater_than: 0 }
  validates :name, uniqueness: true
end
