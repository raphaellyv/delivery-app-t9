require 'rails_helper'

RSpec.describe Deadline, type: :model do
  describe '#valid?' do
    context 'presence' do
      it 'min_distance é obrigatório' do
        # Arrange
        deadline = Deadline.new(min_distance: '')

        # Act
        deadline.valid?

        # Assert
        expect(deadline.errors[:min_distance]).to include('não pode ficar em branco')
      end

      it 'max_distance é obrigatório' do
        # Arrange
        so = ShippingOption.create!(name: 'Entrega Expressa', min_distance: 50 , max_distance: 600, min_weight: 1000, max_weight: 50_000, 
                                      delivery_fee: 5.50)
        deadline = Deadline.new(max_distance: '', shipping_option: so)

        # Act
        deadline.valid?

        # Assert
        expect(deadline.errors[:max_distance]).to include('não pode ficar em branco')
      end

      it 'deadline é obrigatório' do
        # Arrange
        deadline = Deadline.new(deadline: '')

        # Act
        deadline.valid?

        # Assert
        expect(deadline.errors.include? :deadline).to be true
      end
    end

    context 'comparison' do
      it 'min_distance deve ser menor que max_distance' do
        # Arrange
        so = ShippingOption.create!(name: 'Entrega Expressa', min_distance: 50 , max_distance: 600, min_weight: 1000, max_weight: 50_000, 
                                      delivery_fee: 5.50)

        deadline = Deadline.new(min_distance: 70, max_distance: 200, shipping_option: so)

        # Act
        deadline.valid?

        # Assert
        expect(deadline.errors.include? :min_distance).to be false
      end

      it 'min_distance não deve ser igual ao max_distance' do
        # Arrange
        so = ShippingOption.create!(name: 'Entrega Expressa', min_distance: 50 , max_distance: 600, min_weight: 1000, max_weight: 50_000, 
                                      delivery_fee: 5.50)

        deadline = Deadline.new(min_distance: 200, max_distance: 200, shipping_option: so)

        # Act
        deadline.valid?

        # Assert
        expect(deadline.errors[:min_distance]).to include('deve ser menor que 200')
      end

      it 'min_distance não deve ser maior que o max_distance' do
        # Arrange
        so = ShippingOption.create!(name: 'Entrega Expressa', min_distance: 50 , max_distance: 600, min_weight: 1000, max_weight: 50_000, 
                                      delivery_fee: 5.50)

        deadline = Deadline.new(min_distance: 300, max_distance: 200, shipping_option: so)

        # Act
        deadline.valid?

        # Assert
        expect(deadline.errors[:min_distance]).to include('deve ser menor que 200')
      end
    end

    context 'numericality' do
      it 'deadline deve ser maior que 0' do
        # Arrange
        deadline = Deadline.new(deadline: 1)

        # Act
        deadline.valid?

        # Assert
        expect(deadline.errors.include? :deadline).to be false
      end

      it 'deadline não deve ser igual a 0' do
        # Arrange
        deadline = Deadline.new(deadline: 0)

        # Act
        deadline.valid?

        # Assert
        expect(deadline.errors.include? :deadline).to be true
      end

      it 'deadline não deve ser menor que 0' do
        # Arrange
        deadline = Deadline.new(deadline: -1)

        # Act
        deadline.valid?

        # Assert
        expect(deadline.errors.include? :deadline).to be true
      end
    end

    context 'uniqueness' do
      it 'max_distance deve ser única na modalidade de transporte' do
        # Arrange
        so = ShippingOption.create!(name: 'Entrega Expressa', min_distance: 50 , max_distance: 600, min_weight: 1000, max_weight: 50_000, 
                                    delivery_fee: 5.50)

        Deadline.create!(min_distance: 101, max_distance: 500, deadline: 48, shipping_option: so)

        deadline = Deadline.new(min_distance: 90, max_distance: 500, shipping_option: so)

        # Act
        deadline.valid?

        # Assert
        expect(deadline.errors.include? :max_distance).to be true
      end

      it 'max_distance pode se repetir em outra modalidade de transporte' do
        # Arrange
        so_a = ShippingOption.create!(name: 'Entrega Expressa', min_distance: 50 , max_distance: 600, min_weight: 1000, max_weight: 50_000, 
                                    delivery_fee: 5.50)
        so_b = ShippingOption.create!(name: 'Outra Entrega', min_distance: 300 , max_distance: 700, min_weight: 1000, max_weight: 50_000, 
                                      delivery_fee: 3.50)

        Deadline.create!(min_distance: 101, max_distance: 500, deadline: 48, shipping_option: so_a)

        deadline = Deadline.new(min_distance: 90, max_distance: 500, shipping_option: so_b)

        # Act
        deadline.valid?

        # Assert
        expect(deadline.errors.include? :max_distance).to be false
      end

      it 'min_distance deve ser única na modalidade de transporte' do
        # Arrange
        so = ShippingOption.create!(name: 'Entrega Expressa', min_distance: 50 , max_distance: 600, min_weight: 1000, max_weight: 50_000, 
                                    delivery_fee: 5.50)

        Deadline.create!(min_distance: 101, max_distance: 500, deadline: 48, shipping_option: so)

        deadline = Deadline.new(min_distance: 101, max_distance: 200, shipping_option: so)

        # Act
        deadline.valid?

        # Assert
        expect(deadline.errors.include? :min_distance).to be true
      end

      it 'min_distance pode se repetir em outra modalidade de transporte' do
        # Arrange
        so_a = ShippingOption.create!(name: 'Entrega Expressa', min_distance: 50 , max_distance: 600, min_weight: 1000, max_weight: 50_000, 
                                    delivery_fee: 5.50)
        so_b = ShippingOption.create!(name: 'Outra Entrega', min_distance: 300 , max_distance: 700, min_weight: 1000, max_weight: 50_000, 
                                      delivery_fee: 3.50)

        Deadline.create!(min_distance: 101, max_distance: 500, deadline: 48, shipping_option: so_a)

        deadline = Deadline.new(min_distance: 101, max_distance: 600, shipping_option: so_b)

        # Act
        deadline.valid?

        # Assert
        expect(deadline.errors.include? :max_distance).to be false
      end

      it 'deadline deve ser único na modalidade de transporte' do
        # Arrange
        so = ShippingOption.create!(name: 'Entrega Expressa', min_distance: 50 , max_distance: 600, min_weight: 1000, max_weight: 50_000, 
                                    delivery_fee: 5.50)

        Deadline.create!(min_distance: 100, max_distance: 200, deadline: 48, shipping_option: so)

        deadline = Deadline.new(deadline:48, shipping_option: so)

        # Act
        deadline.valid?

        # Assert
        expect(deadline.errors.include? :deadline).to be true
      end

      it 'deadline pode se repetir em outra modalidade de transporte' do
        # Arrange
        so_a = ShippingOption.create!(name: 'Entrega Expressa', min_distance: 50 , max_distance: 600, min_weight: 1000, max_weight: 50_000, 
                                    delivery_fee: 5.50)
        so_b = ShippingOption.create!(name: 'Outra Entrega', min_distance: 300 , max_distance: 700, min_weight: 1000, max_weight: 50_000, 
                                      delivery_fee: 3.50)

        Deadline.create!(min_distance: 101, max_distance: 500, deadline: 48, shipping_option: so_a)

        deadline = Deadline.new(deadline:48, shipping_option: so_b)

        # Act
        deadline.valid?

        # Assert
        expect(deadline.errors.include? :deadline).to be false
      end
    end

    context 'comparação com as distâncias da modalidade de transporte' do
      it 'max_distance deve ser menor que o max_distance da modalidade' do
        # Arrange
        so_a = ShippingOption.create!(name: 'Entrega Expressa', min_distance: 50 , max_distance: 600, min_weight: 1000, max_weight: 50_000, 
                                      delivery_fee: 5.50)

        deadline = Deadline.new(min_distance: 300, max_distance: 500, shipping_option: so_a)

        # Act
        deadline.valid?

        # Assert
        expect(deadline.errors.include? :max_distance).to be false
      end

      it 'max_distance não pode ser maior que o max_distance da modalidade' do
        # Arrange
        so_a = ShippingOption.create!(name: 'Entrega Expressa', min_distance: 50 , max_distance: 600, min_weight: 1000, max_weight: 50_000, 
                                      delivery_fee: 5.50)

        deadline = Deadline.new(min_distance: 300, max_distance: 700, shipping_option: so_a)

        # Act
        deadline.valid?

        # Assert
        expect(deadline.errors.include? :max_distance).to be true
      end

      it 'max_distance pode ser igual ao max_distance da modalidade' do
        # Arrange
        so_a = ShippingOption.create!(name: 'Entrega Expressa', min_distance: 50 , max_distance: 600, min_weight: 1000, max_weight: 50_000, 
                                      delivery_fee: 5.50)

        deadline = Deadline.new(min_distance: 300, max_distance: 600, shipping_option: so_a)

        # Act
        deadline.valid?

        # Assert
        expect(deadline.errors.include? :max_distance).to be false
      end

      it 'min_distance não deve ser menor que o min_distance da modalidade' do
        # Arrange
        so_a = ShippingOption.create!(name: 'Entrega Expressa', min_distance: 50 , max_distance: 600, min_weight: 1000, max_weight: 50_000, 
                                      delivery_fee: 5.50)

        deadline = Deadline.new(min_distance: 40, shipping_option: so_a)

        # Act
        deadline.valid?

        # Assert
        expect(deadline.errors.include? :min_distance).to be true
      end

      it 'min_distance pode ser igual ao min_distance da modalidade' do
        # Arrange
        so_a = ShippingOption.create!(name: 'Entrega Expressa', min_distance: 50 , max_distance: 600, min_weight: 1000, max_weight: 50_000, 
                                      delivery_fee: 5.50)

        deadline = Deadline.new(min_distance: 50, max_distance: 70, shipping_option: so_a)

        # Act
        deadline.valid?

        # Assert
        expect(deadline.errors.include? :min_distance).to be false
      end

      it 'min_distance pode ser maior que o min_distance da modalidade' do
        # Arrange
        so_a = ShippingOption.create!(name: 'Entrega Expressa', min_distance: 50 , max_distance: 600, min_weight: 1000, max_weight: 50_000, 
                                      delivery_fee: 5.50)

        deadline = Deadline.new(min_distance: 60, max_distance: 70, shipping_option: so_a)

        # Act
        deadline.valid?

        # Assert
        expect(deadline.errors.include? :min_distance).to be false
      end
    end
  end
end
