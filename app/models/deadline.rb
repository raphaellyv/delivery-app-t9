class Deadline < ApplicationRecord
  belongs_to :shipping_option

  validates :deadline, :max_distance, :min_distance, presence: true

  validates :min_distance, comparison: { less_than: :max_distance }

  validates :deadline, numericality: { greater_than: 0}

  validates :deadline, uniqueness: { scope: :shipping_option }
  validates :max_distance, uniqueness: { scope: :shipping_option }
  validates :min_distance, uniqueness: { scope: :shipping_option }

  validate :max_distance_is_less_than_or_equal_to_shipping_option_max_distance
  validate :min_distance_is_greater_than_or_equal_to_shipping_option_min_distance

  def max_distance_is_less_than_or_equal_to_shipping_option_max_distance
    if self.max_distance.present? && self.max_distance > self.shipping_option.max_distance
      self.errors.add(:max_distance, "deve ser menor que #{self.shipping_option.max_distance}")
    end
  end

  def min_distance_is_greater_than_or_equal_to_shipping_option_min_distance
    if self.min_distance.present? && self.min_distance < self.shipping_option.min_distance
      self.errors.add(:min_distance, "deve ser maior que #{self.shipping_option.min_distance}")
    end
  end
end
