require 'rails_helper'

describe 'Usuário edita um veículo' do
  it 'e não está autenticado' do
    # Arrange
    so = ShippingOption.create!(name: 'Outra Entrega', min_distance: 60 , max_distance: 700, min_weight: 3000, max_weight: 55_000, 
                                delivery_fee: 3.50)

    vehicle = Vehicle.create!(shipping_option: so, license_plate: 'AAA0000', brand: 'Peugeot', car_model: 'Partner CS', 
                              manufacture_year: '2021', max_weight: 800_000, status: :available)

    # Act
    patch(vehicle_path(vehicle.id), params: { vehicle: { license_plate: '' } })

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
    patch(vehicle_path(vehicle.id), params: { vehicle: { license_plate: 'BBB0000' } })

    # Assert
    expect(response).not_to redirect_to( vehicle_path(vehicle.id))
  end
end