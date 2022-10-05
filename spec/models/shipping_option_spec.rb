require 'rails_helper'

RSpec.describe ShippingOption, type: :model do
  describe '#valid?' do
    context 'presence' do
      it 'delivery_fee é obrigatório' do
        # Arrange
        so = ShippingOption.new(delivery_fee: '')

        # Act
        so.valid?

        # Assert
        expect(so.errors.include? :delivery_fee).to be true
      end

      it 'max_distance é obrigatório' do
        # Arrange
        so = ShippingOption.new(max_distance: '')

        # Act
        so.valid?

        # Assert
        expect(so.errors.include? :max_distance).to be true
      end

      it 'max_weigh é obrigatório' do
        # Arrange
        so = ShippingOption.new(max_weight: '')

        # Act
        so.valid?

        # Assert
        expect(so.errors.include? :max_weight).to be true
      end

      it 'min_distance é obrigatório' do
        # Arrange
        so = ShippingOption.new(min_distance: '')

        # Act
        so.valid?

        # Assert
        expect(so.errors.include? :min_distance).to be true
      end

      it 'min_weight é obrigatório' do
        # Arrange
        so = ShippingOption.new(min_weight: '')

        # Act
        so.valid?

        # Assert
        expect(so.errors.include? :min_weight).to be true
      end

      it 'name é obrigatório' do
        # Arrange
        so = ShippingOption.new(name: '')

        # Act
        so.valid?

        # Assert
        expect(so.errors.include? :name).to be true
      end
    end

    context 'uniqueness' do
      it 'name deve ser único' do
        # Arrange
        ShippingOption.create!(name: 'Entrega Expressa', min_distance: 50 , max_distance: 600, min_weight: 1000, max_weight: 50000, 
                               delivery_fee: 5.50)
                          
        so = ShippingOption.new(name: 'Entrega Expressa')

        # Act
        so.valid?

        # Assert
        expect(so.errors.include? :name).to be true
      end
    end

    context 'numericality' do
      it 'delivery_fee deve ser maior que 0' do
        # Arrange
        so = ShippingOption.new(delivery_fee: 1)

        # Act
        so.valid?

        # Assert
        expect(so.errors.include? :delivery_fee).to be false
      end

      it 'delivery_fee não deve ser igual a 0' do
        # Arrange
        so = ShippingOption.new(delivery_fee: 0)

        # Act
        so.valid?

        # Assert
        expect(so.errors.include? :delivery_fee).to be true
      end

      it 'delivery_fee não deve ser menor que 0' do
        # Arrange
        so = ShippingOption.new(delivery_fee: -1)

        # Act
        so.valid?

        # Assert
        expect(so.errors.include? :delivery_fee).to be true
      end

      it 'max_distance deve ser maior que 0' do
        # Arrange
        so = ShippingOption.new(max_distance: 1)

        # Act
        so.valid?

        # Assert
        expect(so.errors.include? :max_distance).to be false
      end

      it 'max_distance não deve ser igual a 0' do
        # Arrange
        so = ShippingOption.new(max_distance: 0)

        # Act
        so.valid?

        # Assert
        expect(so.errors.include? :max_distance).to be true
      end

      it 'max_distance não deve ser menor que 0' do
        # Arrange
        so = ShippingOption.new(max_distance: -1)

        # Act
        so.valid?

        # Assert
        expect(so.errors.include? :max_distance).to be true
      end

      it 'min_distance deve ser maior que 0' do
        # Arrange
        so = ShippingOption.new(min_distance: 1)

        # Act
        so.valid?

        # Assert
        expect(so.errors.include? :min_distance).to be false
      end

      it 'min_distance não deve ser igual a 0' do
        # Arrange
        so = ShippingOption.new(min_distance: 0)

        # Act
        so.valid?

        # Assert
        expect(so.errors.include? :min_distance).to be true
      end

      it 'min_distance não deve ser menor que 0' do
        # Arrange
        so = ShippingOption.new(min_distance: -1)

        # Act
        so.valid?

        # Assert
        expect(so.errors.include? :min_distance).to be true
      end

      it 'max_weight deve ser maior que 0' do
        # Arrange
        so = ShippingOption.new(max_weight: 1)

        # Act
        so.valid?

        # Assert
        expect(so.errors.include? :max_weight).to be false
      end

      it 'max_weight não deve ser igual a 0' do
        # Arrange
        so = ShippingOption.new(max_weight: 0)

        # Act
        so.valid?

        # Assert
        expect(so.errors.include? :max_weight).to be true
      end

      it 'max_weight não deve ser menor que 0' do
        # Arrange
        so = ShippingOption.new(max_weight: -1)

        # Act
        so.valid?

        # Assert
        expect(so.errors.include? :max_weight).to be true
      end

      it 'min_weight deve ser maior que 0' do
        # Arrange
        so = ShippingOption.new(min_weight: 1)

        # Act
        so.valid?

        # Assert
        expect(so.errors.include? :min_weight).to be false
      end

      it 'min_weight não deve ser igual a 0' do
        # Arrange
        so = ShippingOption.new(min_weight: 0)

        # Act
        so.valid?

        # Assert
        expect(so.errors.include? :min_weight).to be true
      end

      it 'min_weight não deve ser menor que 0' do
        # Arrange
        so = ShippingOption.new(min_weight: -1)

        # Act
        so.valid?

        # Assert
        expect(so.errors.include? :min_weight).to be true
      end
    end
  end

  describe '#disabled?' do
    it 'a modalidade de transporte é criada como inativa' do
      # Arrange
      so = ShippingOption.create!(name: 'Entrega Básica', min_distance: 30 , max_distance: 800, min_weight: 1500, max_weight: 40000, 
                                  delivery_fee: 3.00)


      # Act

      # Assert
      expect(so.disabled?).to be true
    end
  end
end
