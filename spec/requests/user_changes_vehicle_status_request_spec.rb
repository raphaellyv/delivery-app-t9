require 'rails_helper'

describe 'Usuário altera o status de um veículo' do
  context 'para Em Manutenção' do
    it 'e não está autenticado' do
      # Arrange
      so = ShippingOption.create!(name: 'Outra Entrega', min_distance: 60 , max_distance: 700, min_weight: 3000, max_weight: 55_000, 
                                  delivery_fee: 3.50)

      vehicle = Vehicle.create!(shipping_option: so, license_plate: 'AAA0000', brand: 'Peugeot', car_model: 'Partner CS', 
                                manufacture_year: '2021', max_weight: 800_000, status: :available)
  
      # Act
      post(sent_to_maintenance_vehicle_path(vehicle.id))
  
      # Assert
      expect(response).to redirect_to(new_user_session_url)
    end

    it 'como usuário regular' do
      # Arrange
      user = User.create!(name: 'Pessoa', email: 'pessoa@sistemadefrete.com.br', password: 'password', role: :regular)

      so = ShippingOption.create!(name: 'Outra Entrega', min_distance: 60 , max_distance: 700, min_weight: 3000, max_weight: 55_000, 
                                  delivery_fee: 3.50)

      vehicle = Vehicle.create!(shipping_option: so, license_plate: 'AAA0000', brand: 'Peugeot', car_model: 'Partner CS', 
                                manufacture_year: '2021', max_weight: 800_000, status: :available)
  
      # Act
      login_as user
      post(sent_to_maintenance_vehicle_path(vehicle.id))
  
      # Assert
      expect(response).not_to redirect_to(vehicle)
    end
  end

  context 'para Disponível' do
    it 'e não está autenticado' do
      # Arrange
      so = ShippingOption.create!(name: 'Outra Entrega', min_distance: 60 , max_distance: 700, min_weight: 3000, max_weight: 55_000, 
                                  delivery_fee: 3.50)

      vehicle = Vehicle.create!(shipping_option: so, license_plate: 'AAA0000', brand: 'Peugeot', car_model: 'Partner CS', 
                                manufacture_year: '2021', max_weight: 800_000, status: :maintenance)
  
      # Act
      post(make_available_vehicle_path(vehicle.id))
  
      # Assert
      expect(response).to redirect_to(new_user_session_url)
    end

    it 'como usuário regular' do
      # Arrange
      user = User.create!(name: 'Pessoa', email: 'pessoa@sistemadefrete.com.br', password: 'password', role: :regular)

      so = ShippingOption.create!(name: 'Outra Entrega', min_distance: 60 , max_distance: 700, min_weight: 3000, max_weight: 55_000, 
                                  delivery_fee: 3.50)

      vehicle = Vehicle.create!(shipping_option: so, license_plate: 'AAA0000', brand: 'Peugeot', car_model: 'Partner CS', 
                                manufacture_year: '2021', max_weight: 800_000, status: :maintenance)
  
      # Act
      login_as user
      post(make_available_vehicle_path(vehicle.id))
  
      # Assert
      expect(response).not_to redirect_to(vehicle)
    end
  end
end