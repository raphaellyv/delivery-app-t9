require 'rails_helper'

RSpec.describe DetailedOrder, type: :model do
  describe '#valid?' do
    context 'presence' do
      it 'estimated_delivery_date é obrigatório' do
        # Arrange
        detailed_order = DetailedOrder.new(estimated_delivery_date: '')

        # Act
        detailed_order.valid?

        # Assert
        expect(detailed_order.errors.include? :estimated_delivery_date).to be true
      end

      it 'total_price é obrigatório' do
        # Arrange
        detailed_order = DetailedOrder.new(total_price: '')

        # Act
        detailed_order.valid?

        # Assert
        expect(detailed_order.errors.include? :total_price).to be true
      end
    end
  end
end
