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

  describe '#select_vehicle' do
    it 'seleciona um veículo para a ordem de serviço' do
      # Arrange
      user = User.create!(name: 'Pessoa', email: 'pessoa@sistemadefrete.com.br', password: 'password', role: :regular)
    
      order = Order.create!(delivery_address: 'Rua das Palmeiras, 13', delivery_city: 'Rio de Janeiro', delivery_state: 'RJ', 
                            delivery_postal_code: '28200000', recipient: 'Denise Silva', recipient_cpf: '00000000000',
                            recipient_email: 'denise@email.com', recipient_phone_number: '2297523040', 
                            pick_up_address: 'Estrada do Porto, 70', pick_up_city: 'São Paulo', pick_up_state: 'SP', 
                            pick_up_postal_code: '30000000', sku: 'TV32P-SAMSUNG-XPTO90', height: 60, width: 40, length: 100, 
                            weight: 3_000, distance: 300)

      so = ShippingOption.create!(name: 'Entrega Expressa', min_distance: 50 , max_distance: 600, min_weight: 1_000, max_weight: 50_000, 
                                  delivery_fee: 5.50, status: :enabled)

      vehicle_a = Vehicle.create!(shipping_option: so, license_plate: 'BBB0000', brand: 'Fiat', car_model: 'Partner TX', 
                                  manufacture_year: '2020', max_weight: 700_000, status: :available)

      vehicle_b = Vehicle.create!(shipping_option: so, license_plate: 'AAA0000', brand: 'Peugeot', car_model: 'Partner CS', 
                                  manufacture_year: '2021', max_weight: 800_000, status: :en_route)

      detailed_order = DetailedOrder.new(order: order, shipping_option: so)

      # Act
      detailed_order.select_vehicle

      # Assert
      expect(detailed_order.vehicle).to eq vehicle_a
    end
  end

  describe '#set_total_price_and_estimated_delivery_date' do
    it 'atribui o preço total e a previsão de entrega' do
      # Arrange
      user = User.create!(name: 'Pessoa', email: 'pessoa@sistemadefrete.com.br', password: 'password', role: :regular)
    
      order = Order.create!(delivery_address: 'Rua das Palmeiras, 13', delivery_city: 'Rio de Janeiro', delivery_state: 'RJ', 
                            delivery_postal_code: '28200000', recipient: 'Denise Silva', recipient_cpf: '00000000000',
                            recipient_email: 'denise@email.com', recipient_phone_number: '2297523040', 
                            pick_up_address: 'Estrada do Porto, 70', pick_up_city: 'São Paulo', pick_up_state: 'SP', 
                            pick_up_postal_code: '30000000', sku: 'TV32P-SAMSUNG-XPTO90', height: 60, width: 40, length: 100, 
                            weight: 3_000, distance: 300)

      so = ShippingOption.create!(name: 'Entrega Expressa', min_distance: 50 , max_distance: 600, min_weight: 1_000, 
                                  max_weight: 50_000, delivery_fee: 5.50, status: :enabled)

      Price.create!(min_weight: 2_001, max_weight: 4_000, price_per_km: 1.00, shipping_option: so)
      DistanceFee.create!(min_distance: 201, max_distance: 350, fee: 2.50, shipping_option: so)
      Deadline.create!(min_distance: 201, max_distance: 400, deadline: 48, shipping_option: so)                            

      detailed_order = DetailedOrder.new(order: order, shipping_option: so)

      # Act
      detailed_order.set_total_price_and_estimated_delivery_date

      # Assert
      expect(detailed_order.estimated_delivery_date.strftime("%d/%m/%Y")).to eq (Time.now + 48.hours).strftime("%d/%m/%Y")
      expect(detailed_order.total_price).to eq 308
    end
  end
end
