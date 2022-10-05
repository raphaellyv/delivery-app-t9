class ShippingOption < ApplicationRecord
  enum :status, { disabled: 10, enabled: 20 }, default: :disabled

  validates :delivery_fee, :max_distance, :min_distance, :min_weight, :max_weight, :name, presence: true

  validates  :delivery_fee, :max_distance, :min_distance, :max_weight, :min_weight, numericality: { greater_than: 0 }
  
  validates :name, uniqueness: true
end
