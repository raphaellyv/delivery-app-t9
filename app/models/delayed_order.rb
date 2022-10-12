class DelayedOrder < ApplicationRecord
  belongs_to :order
  has_one :detailed_order, through: :order

  validates :cause_of_delay, presence: true
end
