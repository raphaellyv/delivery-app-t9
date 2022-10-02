class Order < ApplicationRecord
  enum :status, { pending: 10, en_route: 20, delivered: 30 }, default: :pending

  before_validation :generate_code, on: :create

  validates :delivery_address, :delivery_city, :delivery_state, :delivery_postal_code, :recipient, 
            :recipient_cpf, :recipient_email, :recipient_phone_number, :pick_up_address, 
            :pick_up_city, :pick_up_state, :pick_up_postal_code, :sku, :height, :width, :length, 
            :weight, :distance, presence: true

  def origin_city_and_state
    "#{pick_up_city} - #{pick_up_state}"
  end

  def destination_city_and_state
    "#{delivery_city} - #{delivery_state}"
  end

  private

  def generate_code
    self.tracking_code = SecureRandom.alphanumeric(15)
  end
end
