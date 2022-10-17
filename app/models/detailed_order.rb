class DetailedOrder < ApplicationRecord
  belongs_to :order
  belongs_to :shipping_option
  belongs_to :vehicle

  validates :estimated_delivery_date, :total_price, presence: true

  def select_vehicle
    self.vehicle = shipping_option.vehicles.available.order(:updated_at).select{ |vehicle| vehicle.max_weight >= order.weight }[0]
  end

  def set_total_price_and_estimated_delivery_date
    quotations = order.generate_quotations
    shipping_options = order.search_possible_shipping_options

    quotation = quotations.find{ |quotation| quotation[:shipping_option] == shipping_option }
    self.total_price = quotation[:price]
    self.estimated_delivery_date = Time.now + quotation[:deadline].hours
  end
end
