require 'rails_helper'

RSpec.describe Price, type: :model do
  describe '#valid?' do
    context 'presence' do
      it 'peso máximo é obrigatório' do
        # Arrange
        price = Price.new(max_weight: '')

        # Act
        price.valid?

        # Assert
        expect(price.errors[:max_weight]).to include('não pode ficar em branco')
      end

      it 'peso mínimo é obrigatório' do
        # Arrange
        price = Price.new(min_weight: '')

        # Act
        price.valid?

        # Assert
        expect(price.errors[:min_weight]).to include('não pode ficar em branco')
      end

      it 'preço por km é obrigatório' do
        # Arrange
        price = Price.new(price_per_km: '')

        # Act
        price.valid?

        # Assert
        expect(price.errors[:price_per_km]).to include('não pode ficar em branco')
      end
    end

    context 'comparison' do
      it 'peso mínimo deve ser menor que peso máximo' do
        # Arrange
        so_a = ShippingOption.create!(name: 'Entrega Expressa', min_distance: 50 , max_distance: 600, 
                                      min_weight: 1_000, max_weight: 50_000, delivery_fee: 5.50)

        price = Price.new(min_weight: 1_000, max_weight: 10_000, shipping_option: so_a)

        # Act
        price.valid?

        # Assert
        expect(price.errors.include? :min_weight).to be false
      end

      it 'peso mínimo não deve ser igual ao peso máximo' do
        # Arrange
        so_a = ShippingOption.create!(name: 'Entrega Expressa', min_distance: 50 , max_distance: 600, 
                                      min_weight: 1_000, max_weight: 50_000, delivery_fee: 5.50)

        price = Price.new(min_weight: 1_000, max_weight: 1_000, shipping_option: so_a)

        # Act
        price.valid?

        # Assert
        expect(price.errors[:min_weight]).to include('deve ser menor que 1000')
      end

      it 'peso mínimo não deve ser maior que peso máximo' do
        # Arrange
        so_a = ShippingOption.create!(name: 'Entrega Expressa', min_distance: 50 , max_distance: 600, 
                                      min_weight: 1_000, max_weight: 50_000, delivery_fee: 5.50)

        price = Price.new(min_weight: 10_000, max_weight: 1_000, shipping_option: so_a)

        # Act
        price.valid?

        # Assert
        expect(price.errors[:min_weight]).to include('deve ser menor que 1000')
      end
    end

    context 'numericality' do
      it 'preço por km deve ser maior que 0' do
        # Arrange
        price = Price.new(price_per_km: 1.00)

        # Act
        price.valid?

        # Assert
        expect(price.errors.include? :price_per_km).to be false
      end

      it 'preço por km não deve ser igual a 0' do
        # Arrange
        price = Price.new(price_per_km: 0.00)

        # Act
        price.valid?

        # Assert
        expect(price.errors.include? :price_per_km).to be true
      end

      it 'preço por km não deve ser menor que 0' do
        # Arrange
        price = Price.new(price_per_km: -1)

        # Act
        price.valid?

        # Assert
        expect(price.errors.include? :price_per_km).to be true
      end
    end

    context 'uniqueness' do
      it 'peso máximo deve ser único na modalidade de transporte' do
        # Arrange
        so = ShippingOption.create!(name: 'Entrega Expressa', min_distance: 50 , max_distance: 600, 
                                    min_weight: 1_000, max_weight: 50_000, delivery_fee: 5.50)

        Price.create!(min_weight: 1_000, max_weight: 3_000, price_per_km: 5.00, shipping_option: so)

        price = Price.new(min_weight: 2_000, max_weight: 3_000, price_per_km: 4.00, shipping_option: so)

        # Act
        price.valid?

        # Assert
        expect(price.errors.include? :max_weight).to be true
      end

      it 'peso máximo pode se repetir em outra modalidade de transporte' do
        # Arrange
        so_a = ShippingOption.create!(name: 'Entrega Expressa', min_distance: 50 , max_distance: 600, 
                                      min_weight: 1_000, max_weight: 50_000, delivery_fee: 5.50)
        so_b = ShippingOption.create!(name: 'Outra Entrega', min_distance: 300 , max_distance: 700, 
                                      min_weight: 1_000, max_weight: 50_000, delivery_fee: 3.50)

        Price.create!(min_weight: 1_000, max_weight: 3_000, price_per_km: 5.00, shipping_option: so_a)

        price = Price.new(min_weight: 2_000, max_weight: 3_000, price_per_km: 4.00, shipping_option: so_b)

        # Act
        price.valid?

        # Assert
        expect(price.errors.include? :max_weight).to be false
      end

      it 'peso mínimo deve ser único na modalidade de transporte' do
        # Arrange
        so = ShippingOption.create!(name: 'Entrega Expressa', min_distance: 50 , max_distance: 600, 
                                    min_weight: 1_000, max_weight: 50_000, delivery_fee: 5.50)

        Price.create!(min_weight: 1_000, max_weight: 2_000, price_per_km: 5.00, shipping_option: so)

        price = Price.new(min_weight: 1_000, max_weight: 3_000, price_per_km: 4.00, shipping_option: so)

        # Act
        price.valid?

        # Assert
        expect(price.errors.include? :min_weight).to be true
      end

      it 'peso mínimo pode se repetir em outra modalidade de transporte' do
        # Arrange
        so_a = ShippingOption.create!(name: 'Entrega Expressa', min_distance: 50 , max_distance: 600, 
                                      min_weight: 1_000, max_weight: 50_000, delivery_fee: 5.50)
        so_b = ShippingOption.create!(name: 'Outra Entrega', min_distance: 300 , max_distance: 700, 
                                      min_weight: 1_000, max_weight: 50_000, delivery_fee: 3.50)

        Price.create!(min_weight: 1_000, max_weight: 2_000, price_per_km: 5.00, shipping_option: so_a)

        price = Price.new(min_weight: 1_000, max_weight: 3_000, price_per_km: 4.00, shipping_option: so_b)

        # Act
        price.valid?

        # Assert
        expect(price.errors.include? :min_weight).to be false
      end

      it 'preço por km deve ser único na modalidade de transporte' do
        # Arrange
        so = ShippingOption.create!(name: 'Entrega Expressa', min_distance: 50 , max_distance: 600, 
                                    min_weight: 1_000, max_weight: 50_000, delivery_fee: 5.50)

        Price.create!(min_weight: 1_000, max_weight: 2_000, price_per_km: 5.00, shipping_option: so)

        price = Price.new(price_per_km: 5.00, shipping_option: so)

        # Act
        price.valid?

        # Assert
        expect(price.errors.include? :price_per_km).to be true
      end

      it 'preço por km pode se repetir em outra modalidade de transporte' do
        # Arrange
        so_a = ShippingOption.create!(name: 'Entrega Expressa', min_distance: 50 , max_distance: 600, 
                                      min_weight: 1_000, max_weight: 50_000, delivery_fee: 5.50)
        so_b = ShippingOption.create!(name: 'Outra Entrega', min_distance: 300 , max_distance: 700, 
                                      min_weight: 1_000, max_weight: 50_000, delivery_fee: 3.50)

        Price.create!(min_weight: 1_000, max_weight: 2_000, price_per_km: 5.00, shipping_option: so_a)

        price = Price.new(price_per_km: 5.00, shipping_option: so_b)

        # Act
        price.valid?

        # Assert
        expect(price.errors.include? :price_per_km).to be false
      end
    end

    context 'comparação com o peso da modalidade de transporte' do
      it 'peso máximo não pode ser maior que o peso máximo da modalidade' do
        # Arrange
        so_a = ShippingOption.create!(name: 'Entrega Expressa', min_distance: 50 , max_distance: 600, 
                                      min_weight: 1_000, max_weight: 50_000, delivery_fee: 5.50)

        price = Price.new(min_weight: 30_000, max_weight: 60_000, shipping_option: so_a)

        # Act
        price.valid?

        # Assert
        expect(price.errors[:max_weight]).to include('deve ser menor que ou igual a 50000')
      end

      it 'peso máximo pode ser igual ao peso máximo da modalidade' do
        # Arrange
        so_a = ShippingOption.create!(name: 'Entrega Expressa', min_distance: 50 , max_distance: 600, 
                                      min_weight: 1_000, max_weight: 50_000, delivery_fee: 5.50)

        price = Price.new(min_weight: 30_000, max_weight: 50_000, shipping_option: so_a)

        # Act
        price.valid?

        # Assert
        expect(price.errors.include? :max_weight).to be false
      end

      it 'peso máximo pode ser menor que peso máximo da modalidade' do
        # Arrange
        so_a = ShippingOption.create!(name: 'Entrega Expressa', min_distance: 50 , max_distance: 600, 
                                      min_weight: 1_000, max_weight: 50_000, delivery_fee: 5.50)

        price = Price.new(min_weight: 30_000, max_weight: 40_000, shipping_option: so_a)

        # Act
        price.valid?

        # Assert
        expect(price.errors.include? :max_weight).to be false
      end

      it 'peso mínimo não pode ser menor que peso mínimo da modalidade' do
        # Arrange
        so_a = ShippingOption.create!(name: 'Entrega Expressa', min_distance: 50 , max_distance: 600, 
                                      min_weight: 1_000, max_weight: 50_000, delivery_fee: 5.50)

        price = Price.new(min_weight: 500, max_weight: 3_000, shipping_option: so_a)

        # Act
        price.valid?

        # Assert
        expect(price.errors[:min_weight]).to include('deve ser maior que ou igual a 1000')
      end
      
      it 'peso mínimo pode ser igual ao peso mínimo da modalidade' do
        # Arrange
        so_a = ShippingOption.create!(name: 'Entrega Expressa', min_distance: 50 , max_distance: 600, 
                                      min_weight: 1_000, max_weight: 50_000, delivery_fee: 5.50)

        price = Price.new(min_weight: 1_000, max_weight: 3_000, shipping_option: so_a)

        # Act
        price.valid?

        # Assert
        expect(price.errors.include? :min_weight).to be false
      end

      it 'peso mínimo pode ser maior que peso mínimo da modalidade' do
        # Arrange
        so_a = ShippingOption.create!(name: 'Entrega Expressa', min_distance: 50 , max_distance: 600, 
                                      min_weight: 1_000, max_weight: 50_000, delivery_fee: 5.50)

        price = Price.new(min_weight: 2_000, max_weight: 3_000, shipping_option: so_a)

        # Act
        price.valid?

        # Assert
        expect(price.errors.include? :min_weight).to be false
      end
    end
  end
end
