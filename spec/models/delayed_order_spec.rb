require 'rails_helper'

RSpec.describe DelayedOrder, type: :model do
  describe '#valid?' do
    context 'presence' do
      it 'cause_of_delay é obrigatório' do
        # Arrange
        delayed_order = DelayedOrder.new(cause_of_delay: '')

        # Act
        delayed_order.valid?

        # Assert
        expect(delayed_order.errors.include? :cause_of_delay).to be true
      end
    end
  end
end
