class Order < ApplicationRecord
  has_one :detailed_order
  has_one :shipping_option, through: :detailed_order
  has_one :vehicle, through: :detailed_order
  has_one :delayed_order
  
  enum :status, { pending: 10, en_route: 20, delivered_late: 30, delivered_on_time: 40 }, default: :pending

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

  def search_prices
    Price.where(["min_weight <= ? and max_weight >= ?", weight, weight])
  end

  def search_deadlines
    Deadline.where(["min_distance <= ? and max_distance >= ?", distance, distance])
  end

  def search_distance_fees
    DistanceFee.where(["min_distance <= ? and max_distance >= ?", distance, distance])
  end

  def search_possible_shipping_options
    prices = search_prices
    deadlines = search_deadlines
    distance_fees = search_distance_fees

    @shipping_options = []

    deadlines.each do |deadline|
      prices.each do |price|
        if (price.shipping_option == deadline.shipping_option)
          distance_fees.each do |distance_fee|
            if (distance_fee.shipping_option == price.shipping_option) && (distance_fee.shipping_option.enabled?)
              @shipping_options << distance_fee.shipping_option
            end
          end
        end
      end
    end
    @shipping_options
  end

  def generate_quotations
    @shipping_options = search_possible_shipping_options
    @quotations = []

    @shipping_options.each do |so|
      @quotations << so.generate_quotation_for(self)
    end
    @quotations
  end

  private

  def generate_code
    self.tracking_code = SecureRandom.alphanumeric(15).upcase
  end
end
