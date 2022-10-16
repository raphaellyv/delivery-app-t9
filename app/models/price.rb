class Price < ApplicationRecord
  belongs_to :shipping_option

  validates :max_weight, :min_weight, :price_per_km, presence: true
  validates :min_weight, comparison: { less_than: :max_weight }
  validates :price_per_km, numericality: { greater_than: 0 } 
  validates :max_weight, :min_weight, :price_per_km, uniqueness: { scope: :shipping_option }
  validate :max_weight_is_less_than_or_equal_to_shipping_option_max_weight
  validate :min_weight_is_greater_than_or_equal_to_shipping_option_min_weight

  def max_weight_is_less_than_or_equal_to_shipping_option_max_weight
    if self.max_weight.present? && self.max_weight > self.shipping_option.max_weight
      self.errors.add(:max_weight, "deve ser menor que ou igual a #{self.shipping_option.max_weight}")
    end
  end

  def min_weight_is_greater_than_or_equal_to_shipping_option_min_weight
    if self.min_weight.present? && self.min_weight < self.shipping_option.min_weight
      self.errors.add(:min_weight, "deve ser maior que ou igual a #{self.shipping_option.min_weight}")
    end
  end
end
