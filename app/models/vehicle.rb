class Vehicle < ApplicationRecord
  has_many :detailed_orders
  enum :status, { available: 10, en_route: 20, maintenance: 30 }, default: :available
  
  belongs_to :shipping_option

  validates :brand, :car_model, :license_plate, :manufacture_year, :max_weight, presence: true
  
  validates :manufacture_year, format: { with: /\A\d+\Z/ }

  validates :license_plate, length: { is: 7 }
  validates :manufacture_year, length: { is: 4 }

  validates :max_weight, numericality: { greater_than: 0 }

  validates :license_plate, uniqueness: true
end
