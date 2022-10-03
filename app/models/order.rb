class Order < ApplicationRecord
  enum :status, { pending: 10, en_route: 20, delivered: 30 }, default: :pending

  before_validation :generate_code, on: :create

  validates :delivery_address, :delivery_city, :delivery_state, :delivery_postal_code, :recipient, 
            :recipient_cpf, :recipient_email, :recipient_phone_number, :pick_up_address, 
            :pick_up_city, :pick_up_state, :pick_up_postal_code, :sku, :height, :width, :length, 
            :weight, :distance, presence: true

  validates :delivery_postal_code, :pick_up_postal_code, length: { is: 8 }
  validates :recipient_cpf, length: { is: 11 }
  validates :recipient_phone_number, length: { in: 10..11 }
  validates :sku, length: { is: 20 }
  
  validates :delivery_postal_code, :pick_up_postal_code, :recipient_cpf, :recipient_phone_number, format: { with: /\A\d+\Z/ }
  validates :recipient_email, format: { with: URI::MailTo::EMAIL_REGEXP } 
  
  validates :height, :width, :length, :weight, :distance, numericality: { greater_than: 0 }

  def destination_city_and_state
    "#{delivery_city} - #{delivery_state}"
  end

  def dimensions
    "#{length} cm x #{width} cm x #{height} cm"
  end

  def formatted_cpf
    "#{recipient_cpf[0, 3]}.#{recipient_cpf[3, 3]}.#{recipient_cpf[6, 3]}-#{recipient_cpf[9, 2]}"
  end

  def formatted_phone_number
    "(#{recipient_phone_number[0, 2]}) #{recipient_phone_number[2, (recipient_phone_number.length - 6)]}-#{
        recipient_phone_number[-4, 4]}"
  end

  def formatted_delivery_postal_code
    "#{delivery_postal_code[0, 2]}.#{delivery_postal_code[2, 3]}-#{delivery_postal_code[5, 3]}"
  end

  def formatted_pick_up_postal_code
    "#{pick_up_postal_code[0, 2]}.#{pick_up_postal_code[2, 3]}-#{pick_up_postal_code[5, 3]}"
  end

  def full_delivery_address
    "#{delivery_address} - #{delivery_city} - #{delivery_state}"
  end

  def full_pick_up_address
    "#{pick_up_address} - #{pick_up_city} - #{pick_up_state}"
  end
  
  def origin_city_and_state
    "#{pick_up_city} - #{pick_up_state}"
  end

  private

  def generate_code
    self.tracking_code = SecureRandom.alphanumeric(15).upcase
  end
end
