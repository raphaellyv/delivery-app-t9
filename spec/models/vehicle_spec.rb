require 'rails_helper'

RSpec.describe Vehicle, type: :model do
  describe '#valid?' do
    context 'presence' do
      it 'brand é obrigatório' do
        # Arrange
        vehicle = Vehicle.new(brand: '')

        # Act
        vehicle.valid?

        # Assert
        expect(vehicle.errors.include? :brand).to be true
      end

      it 'car_model é obrigatório' do
        # Arrange
        vehicle = Vehicle.new(car_model: '')

        # Act
        vehicle.valid?

        # Assert
        expect(vehicle.errors.include? :car_model).to be true
      end

      it 'license_plate é obrigatório' do
        # Arrange
        vehicle = Vehicle.new(license_plate: '')

        # Act
        vehicle.valid?

        # Assert
        expect(vehicle.errors.include? :license_plate).to be true
      end

      it 'manufacture_year é obrigatório' do
        # Arrange
        vehicle = Vehicle.new(manufacture_year: '')

        # Act
        vehicle.valid?

        # Assert
        expect(vehicle.errors.include? :manufacture_year).to be true
      end

      it 'max_weight é obrigatório' do
        # Arrange
        vehicle = Vehicle.new(max_weight: '')

        # Act
        vehicle.valid?

        # Assert
        expect(vehicle.errors.include? :max_weight).to be true
      end
    end

    context 'format' do
      it 'manufacture_year deve conter somente números' do
        # Arrange
        vehicle = Vehicle.new(manufacture_year: 'AB12')

        # Act
        vehicle.valid?

        # Assert
        expect(vehicle.errors.include? :manufacture_year).to be true
      end
    end

    context 'length' do
      it 'license_plate deve ter 7 dígitos' do
        # Arrange
        vehicle = Vehicle.new(license_plate: 'ABC1234')

        # Act
        vehicle.valid?

        # Assert
        expect(vehicle.errors.include? :license_plate).to be false
      end

      it 'license_plate não deve ter mais que 7 dígitos' do
        # Arrange
        vehicle = Vehicle.new(license_plate: 'ABC12345')

        # Act
        vehicle.valid?

        # Assert
        expect(vehicle.errors.include? :license_plate).to be true
      end

      it 'license_plate não deve ter menos que 7 dígitos' do
        # Arrange
        vehicle = Vehicle.new(license_plate: 'ABC123')

        # Act
        vehicle.valid?

        # Assert
        expect(vehicle.errors.include? :license_plate).to be true
      end

      it 'manufacture_year deve ter 4 dígitos' do
        # Arrange
        vehicle = Vehicle.new(manufacture_year: '1234')

        # Act
        vehicle.valid?

        # Assert
        expect(vehicle.errors.include? :manufacture_year).to be false
      end

      it 'manufacture_year não deve ter mais que 4 dígitos' do
        # Arrange
        vehicle = Vehicle.new(manufacture_year: '12345')

        # Act
        vehicle.valid?

        # Assert
        expect(vehicle.errors.include? :manufacture_year).to be true
      end

      it 'manufacture_year não deve ter menos que 4 dígitos' do
        # Arrange
        vehicle = Vehicle.new(manufacture_year: '123')

        # Act
        vehicle.valid?

        # Assert
        expect(vehicle.errors.include? :manufacture_year).to be true
      end
    end

    context 'numericality' do
      it 'max_weight deve ser maior que 0' do
        # Arrange
        vehicle = Vehicle.new(max_weight: 1)

        # Act
        vehicle.valid?

        # Assert
        expect(vehicle.errors.include? :max_weight).to be false
      end

      it 'max_weight não deve ser igual a 0' do
        # Arrange
        vehicle = Vehicle.new(max_weight: 0)

        # Act
        vehicle.valid?

        # Assert
        expect(vehicle.errors.include? :max_weight).to be true
      end

      it 'max_weight não deve ser menor que 0' do
        # Arrange
        vehicle = Vehicle.new(max_weight: -1)

        # Act
        vehicle.valid?

        # Assert
        expect(vehicle.errors.include? :max_weight).to be true
      end
    end

    context 'uniqueness' do
      it 'license_plate deve ser única' do
        # Arrange
        so_a = ShippingOption.create!(name: 'Entrega Básica', min_distance: 30 , max_distance: 800, min_weight: 1500, max_weight: 40000, 
                                      delivery_fee: 3.00)

        Vehicle.create!(shipping_option: so_a, license_plate: 'AAA0000', brand: 'Peugeot', car_model: 'Partner CS', manufacture_year: '2021',
                        max_weight: 800_000)
        
        vehicle = Vehicle.new(license_plate: 'AAA0000')
                        
        # Act
        vehicle.valid?

        # Assert
        expect(vehicle.errors.include? :license_plate).to be true
      end
    end
  end

  describe '#available?' do
    it 'o veículo é criado como disponível' do
      # Arrange
      so_a = ShippingOption.create!(name: 'Entrega Básica', min_distance: 30 , max_distance: 800, min_weight: 1500, max_weight: 40000, 
                                    delivery_fee: 3.00)

      vehicle = Vehicle.create!(shipping_option: so_a, license_plate: 'AAA0000', brand: 'Peugeot', car_model: 'Partner CS', manufacture_year: '2021',
                                max_weight: 800_000)                            


      # Act

      # Assert
      expect(vehicle.available?).to be true
    end
  end
end
