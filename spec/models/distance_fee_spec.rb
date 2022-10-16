require 'rails_helper'

RSpec.describe DistanceFee, type: :model do
  describe '#valid?' do
    context 'presence' do
      it 'fee é obrigatório' do
        # Arrange
        distance_fee = DistanceFee.new(fee: '')

        # Act
        distance_fee.valid?

        # Assert
        expect(distance_fee.errors[:fee]).to include('não pode ficar em branco')
      end

      it 'max_distance é obrigatório' do
        # Arrange
        distance_fee = DistanceFee.new(max_distance: '')

        # Act
        distance_fee.valid?

        # Assert
        expect(distance_fee.errors[:max_distance]).to include('não pode ficar em branco')
      end

      it 'min_distance é obrigatório' do
        # Arrange
        distance_fee = DistanceFee.new(min_distance: '')

        # Act
        distance_fee.valid?

        # Assert
        expect(distance_fee.errors[:min_distance]).to include('não pode ficar em branco')
      end
    end

    context 'comparison' do
      it 'min_distance deve ser menor que max_distance' do
        # Arrange
        so_a = ShippingOption.create!(name: 'Entrega Expressa', min_distance: 50 , max_distance: 600, 
                                      min_weight: 1_000, max_weight: 50_000, delivery_fee: 5.50)

        distance_fee = DistanceFee.new(min_distance: 60, max_distance: 100, shipping_option: so_a)

        # Act
        distance_fee.valid?

        # Assert
        expect(distance_fee.errors.include? :min_distance).to be false
      end

      it 'min_distance não deve ser igual ao max_distance' do
        # Arrange
        so_a = ShippingOption.create!(name: 'Entrega Expressa', min_distance: 50 , max_distance: 600, 
                                      min_weight: 1_000, max_weight: 50_000, delivery_fee: 5.50)

        distance_fee = DistanceFee.new(min_distance: 60, max_distance: 60, shipping_option: so_a)

        # Act
        distance_fee.valid?

        # Assert
        expect(distance_fee.errors.include? :min_distance).to be true
      end

      it 'min_distance não deve ser maior que max_distance' do
        # Arrange
        so_a = ShippingOption.create!(name: 'Entrega Expressa', min_distance: 50 , max_distance: 600, 
                                      min_weight: 1_000, max_weight: 50_000, delivery_fee: 5.50)

        distance_fee = DistanceFee.new(min_distance: 100, max_distance: 60, shipping_option: so_a)

        # Act
        distance_fee.valid?

        # Assert
        expect(distance_fee.errors.include? :min_distance).to be true
      end
    end

    context 'numericality' do
      it 'fee deve ser maior que 0' do
        # Arrange
        distance_fee = DistanceFee.new(fee: 1.00)

        # Act
        distance_fee.valid?

        # Assert
        expect(distance_fee.errors.include? :fee).to be false
      end

      it 'fee não deve ser igual a 0' do
        # Arrange
        distance_fee = DistanceFee.new(fee: 0.00)

        # Act
        distance_fee.valid?

        # Assert
        expect(distance_fee.errors.include? :fee).to be true
      end

      it 'fee não deve ser menor que 0' do
        # Arrange
        distance_fee = DistanceFee.new(fee: -1)

        # Act
        distance_fee.valid?

        # Assert
        expect(distance_fee.errors.include? :fee).to be true
      end
    end

    context 'uniqueness' do
      it 'max_distance deve ser único na modalidade de transporte' do
        # Arrange
        so = ShippingOption.create!(name: 'Entrega Expressa', min_distance: 50 , max_distance: 600, 
                                    min_weight: 1_000, max_weight: 50_000, delivery_fee: 5.50)

        DistanceFee.create!(min_distance: 60, max_distance: 100, fee: 1.00, shipping_option: so)

        distance_fee = DistanceFee.new(min_distance: 70, max_distance: 100, fee: 1.00, shipping_option: so)

        # Act
        distance_fee.valid?

        # Assert
        expect(distance_fee.errors.include? :max_distance).to be true
      end

      it 'max_distance pode se repetir em outra modalidade de transporte' do
        # Arrange
        so_a = ShippingOption.create!(name: 'Entrega Expressa', min_distance: 50 , max_distance: 600, 
                                      min_weight: 1_000, max_weight: 50_000, delivery_fee: 5.50)
        so_b = ShippingOption.create!(name: 'Outra Entrega', min_distance: 300 , max_distance: 700, 
                                      min_weight: 1_000, max_weight: 50_000, delivery_fee: 3.50)

        DistanceFee.create!(min_distance: 60, max_distance: 550, fee: 1.00, shipping_option: so_a)

        distance_fee = DistanceFee.new(min_distance: 350, max_distance: 550, fee: 1.00, shipping_option: so_b)

        # Act
        distance_fee.valid?

        # Assert
        expect(distance_fee.errors.include? :max_distance).to be false
      end

      it 'min_distance deve ser único na modalidade de transporte' do
        # Arrange
        so = ShippingOption.create!(name: 'Entrega Expressa', min_distance: 50 , max_distance: 600, 
                                    min_weight: 1_000, max_weight: 50_000, delivery_fee: 5.50)

        DistanceFee.create!(min_distance: 60, max_distance: 100, fee: 1.00, shipping_option: so)

        distance_fee = DistanceFee.new(min_distance: 60, max_distance: 200, fee: 1.00, shipping_option: so)

        # Act
        distance_fee.valid?

        # Assert
        expect(distance_fee.errors.include? :min_distance).to be true
      end

      it 'min_distance pode se repetir em outra modalidade de transporte' do
        # Arrange
        so_a = ShippingOption.create!(name: 'Entrega Expressa', min_distance: 50 , max_distance: 600, 
                                      min_weight: 1_000, max_weight: 50_000, delivery_fee: 5.50)
        so_b = ShippingOption.create!(name: 'Outra Entrega', min_distance: 300 , max_distance: 700, 
                                      min_weight: 1_000, max_weight: 50_000, delivery_fee: 3.50)

        DistanceFee.create!(min_distance: 350, max_distance: 550, fee: 1.00, shipping_option: so_a)

        distance_fee = DistanceFee.new(min_distance: 350, max_distance: 650, fee: 1.00, shipping_option: so_b)

        # Act
        distance_fee.valid?

        # Assert
        expect(distance_fee.errors.include? :min_distance).to be false
      end

      it 'fee deve ser único na modalidade de transporte' do
        # Arrange
        so = ShippingOption.create!(name: 'Entrega Expressa', min_distance: 50 , max_distance: 600, 
                                    min_weight: 1_000, max_weight: 50_000, delivery_fee: 5.50)

        DistanceFee.create!(min_distance: 60, max_distance: 100, fee: 1.00, shipping_option: so)

        distance_fee = DistanceFee.new(fee: 1.00, shipping_option: so)

        # Act
        distance_fee.valid?

        # Assert
        expect(distance_fee.errors.include? :fee).to be true
      end

      it 'fee pode se repetir em outra modalidade de transporte' do
        # Arrange
        so_a = ShippingOption.create!(name: 'Entrega Expressa', min_distance: 50 , max_distance: 600, 
                                      min_weight: 1_000, max_weight: 50_000, delivery_fee: 5.50)
        so_b = ShippingOption.create!(name: 'Outra Entrega', min_distance: 300 , max_distance: 700, 
                                      min_weight: 1_000, max_weight: 50_000, delivery_fee: 3.50)

        DistanceFee.create!(min_distance: 350, max_distance: 550, fee: 1.00, shipping_option: so_a)

        distance_fee = DistanceFee.new(fee: 1.00, shipping_option: so_b)

        # Act
        distance_fee.valid?

        # Assert
        expect(distance_fee.errors.include? :fee).to be false
      end
    end

    context 'comparação com a distância da modalidade de transporte' do
      it 'max_distance não pode ser maior que o max_distance da modalidade' do
        # Arrange
        so = ShippingOption.create!(name: 'Entrega Expressa', min_distance: 50 , max_distance: 600, 
                                    min_weight: 1_000, max_weight: 50_000, delivery_fee: 5.50)

        distance_fee = DistanceFee.new(min_distance: 60, max_distance: 650, shipping_option: so)

        # Act
        distance_fee.valid?

        # Assert
        expect(distance_fee.errors[:max_distance]).to include('deve ser menor que ou igual a 600')
      end

      it 'max_distance pode ser igual ao max_distance da modalidade' do
        # Arrange
        so = ShippingOption.create!(name: 'Entrega Expressa', min_distance: 50 , max_distance: 600, 
                                    min_weight: 1_000, max_weight: 50_000, delivery_fee: 5.50)

        distance_fee = DistanceFee.new(min_distance: 60, max_distance: 600, shipping_option: so)

        # Act
        distance_fee.valid?

        # Assert
        expect(distance_fee.errors.include? :max_distance).to be false
      end

      it 'max_distance pode ser menor que o max_distance da modalidade' do
        # Arrange
        so = ShippingOption.create!(name: 'Entrega Expressa', min_distance: 50 , max_distance: 600, 
                                    min_weight: 1_000, max_weight: 50_000, delivery_fee: 5.50)

        distance_fee = DistanceFee.new(min_distance: 60, max_distance: 80, shipping_option: so)

        # Act
        distance_fee.valid?

        # Assert
        expect(distance_fee.errors.include? :max_distance).to be false
      end

      it 'min_distance não pode ser menor que o min_distance da modalidade' do
        # Arrange
        so = ShippingOption.create!(name: 'Entrega Expressa', min_distance: 50 , max_distance: 600, 
                                    min_weight: 1_000, max_weight: 50_000, delivery_fee: 5.50)

        distance_fee = DistanceFee.new(min_distance: 40, max_distance: 80, shipping_option: so)

        # Act
        distance_fee.valid?

        # Assert
        expect(distance_fee.errors[:min_distance]).to include('deve ser maior que ou igual a 50')
      end

      it 'min_distance pode ser igual ao min_distance da modalidade' do
        # Arrange
        so = ShippingOption.create!(name: 'Entrega Expressa', min_distance: 50 , max_distance: 600, 
                                    min_weight: 1_000, max_weight: 50_000, delivery_fee: 5.50)

        distance_fee = DistanceFee.new(min_distance: 50, max_distance: 80, shipping_option: so)

        # Act
        distance_fee.valid?

        # Assert
        expect(distance_fee.errors.include? :min_distance).to be false
      end

      it 'min_distance pode ser maior que o min_distance da modalidade' do
        # Arrange
        so = ShippingOption.create!(name: 'Entrega Expressa', min_distance: 50 , max_distance: 600, 
                                    min_weight: 1_000, max_weight: 50_000, delivery_fee: 5.50)

        distance_fee = DistanceFee.new(min_distance: 60, max_distance: 80, shipping_option: so)

        # Act
        distance_fee.valid?

        # Assert
        expect(distance_fee.errors.include? :min_distance).to be false
      end
    end
  end
end
