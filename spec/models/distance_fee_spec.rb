require 'rails_helper'

RSpec.describe DistanceFee, type: :model do
  describe '#valid?' do
    context 'presence' do
      it 'taxa é obrigatória' do
        # Arrange
        distance_fee = DistanceFee.new(fee: '')

        # Act
        distance_fee.valid?

        # Assert
        expect(distance_fee.errors[:fee]).to include('não pode ficar em branco')
      end

      it 'distância máxima é obrigatória' do
        # Arrange
        distance_fee = DistanceFee.new(max_distance: '')

        # Act
        distance_fee.valid?

        # Assert
        expect(distance_fee.errors[:max_distance]).to include('não pode ficar em branco')
      end

      it 'distância mínima é obrigatória' do
        # Arrange
        distance_fee = DistanceFee.new(min_distance: '')

        # Act
        distance_fee.valid?

        # Assert
        expect(distance_fee.errors[:min_distance]).to include('não pode ficar em branco')
      end
    end

    context 'comparison' do
      it 'distância mínima deve ser menor que a distância máxima' do
        # Arrange
        so_a = ShippingOption.create!(name: 'Entrega Expressa', min_distance: 50 , max_distance: 600, 
                                      min_weight: 1_000, max_weight: 50_000, delivery_fee: 5.50)

        distance_fee = DistanceFee.new(min_distance: 60, max_distance: 100, shipping_option: so_a)

        # Act
        distance_fee.valid?

        # Assert
        expect(distance_fee.errors.include? :min_distance).to be false
      end

      it 'distância mínima não deve ser igual à distância máxima' do
        # Arrange
        so_a = ShippingOption.create!(name: 'Entrega Expressa', min_distance: 50 , max_distance: 600, 
                                      min_weight: 1_000, max_weight: 50_000, delivery_fee: 5.50)

        distance_fee = DistanceFee.new(min_distance: 60, max_distance: 60, shipping_option: so_a)

        # Act
        distance_fee.valid?

        # Assert
        expect(distance_fee.errors.include? :min_distance).to be true
      end

      it 'distância mínima não deve ser maior que a distância máxima' do
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
      it 'taxa deve ser maior que 0' do
        # Arrange
        distance_fee = DistanceFee.new(fee: 1.00)

        # Act
        distance_fee.valid?

        # Assert
        expect(distance_fee.errors.include? :fee).to be false
      end

      it 'taxa não deve ser igual a 0' do
        # Arrange
        distance_fee = DistanceFee.new(fee: 0.00)

        # Act
        distance_fee.valid?

        # Assert
        expect(distance_fee.errors.include? :fee).to be true
      end

      it 'taxa não deve ser menor que 0' do
        # Arrange
        distance_fee = DistanceFee.new(fee: -1)

        # Act
        distance_fee.valid?

        # Assert
        expect(distance_fee.errors.include? :fee).to be true
      end
    end

    context 'uniqueness' do
      it 'distância máxima deve ser única na modalidade de transporte' do
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

      it 'distância máxima pode se repetir em outra modalidade de transporte' do
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

      it 'distância mínima deve ser única na modalidade de transporte' do
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

      it 'distância mínima pode se repetir em outra modalidade de transporte' do
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

      it 'taxa deve ser única na modalidade de transporte' do
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

      it 'taxa pode se repetir em outra modalidade de transporte' do
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
      it 'distância máxima não pode ser maior que a distância máxima da modalidade' do
        # Arrange
        so = ShippingOption.create!(name: 'Entrega Expressa', min_distance: 50 , max_distance: 600, 
                                    min_weight: 1_000, max_weight: 50_000, delivery_fee: 5.50)

        distance_fee = DistanceFee.new(min_distance: 60, max_distance: 650, shipping_option: so)

        # Act
        distance_fee.valid?

        # Assert
        expect(distance_fee.errors[:max_distance]).to include('deve ser menor que ou igual a 600')
      end

      it 'distância máxima pode ser igual à distância máxima da modalidade' do
        # Arrange
        so = ShippingOption.create!(name: 'Entrega Expressa', min_distance: 50 , max_distance: 600, 
                                    min_weight: 1_000, max_weight: 50_000, delivery_fee: 5.50)

        distance_fee = DistanceFee.new(min_distance: 60, max_distance: 600, shipping_option: so)

        # Act
        distance_fee.valid?

        # Assert
        expect(distance_fee.errors.include? :max_distance).to be false
      end

      it 'distância máxima pode ser menor que a distância máxima da modalidade' do
        # Arrange
        so = ShippingOption.create!(name: 'Entrega Expressa', min_distance: 50 , max_distance: 600, 
                                    min_weight: 1_000, max_weight: 50_000, delivery_fee: 5.50)

        distance_fee = DistanceFee.new(min_distance: 60, max_distance: 80, shipping_option: so)

        # Act
        distance_fee.valid?

        # Assert
        expect(distance_fee.errors.include? :max_distance).to be false
      end

      it 'distância mínima não pode ser menor que a distância mínima da modalidade' do
        # Arrange
        so = ShippingOption.create!(name: 'Entrega Expressa', min_distance: 50 , max_distance: 600, 
                                    min_weight: 1_000, max_weight: 50_000, delivery_fee: 5.50)

        distance_fee = DistanceFee.new(min_distance: 40, max_distance: 80, shipping_option: so)

        # Act
        distance_fee.valid?

        # Assert
        expect(distance_fee.errors[:min_distance]).to include('deve ser maior que ou igual a 50')
      end

      it 'distância mínima pode ser igual à distância mínima da modalidade' do
        # Arrange
        so = ShippingOption.create!(name: 'Entrega Expressa', min_distance: 50 , max_distance: 600, 
                                    min_weight: 1_000, max_weight: 50_000, delivery_fee: 5.50)

        distance_fee = DistanceFee.new(min_distance: 50, max_distance: 80, shipping_option: so)

        # Act
        distance_fee.valid?

        # Assert
        expect(distance_fee.errors.include? :min_distance).to be false
      end

      it 'distância mínima pode ser maior que a distância mínima da modalidade' do
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
