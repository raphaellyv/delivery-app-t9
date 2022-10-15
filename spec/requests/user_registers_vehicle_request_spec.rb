require 'rails_helper'

describe 'Usuário cadastra um veículo' do
  it 'e não está autenticado' do
    # Arrange
    so = ShippingOption.create!(name: 'Outra Entrega', min_distance: 60 , max_distance: 700, min_weight: 3000, max_weight: 55_000, 
                                delivery_fee: 3.50)
    
    # Act
    post(vehicles_path, params: { vehicle: { shipping_option: so, license_plate: 'AAA0000', brand: 'Peugeot', car_model: 'Partner CS', 
                                             manufacture_year: '2021', max_weight: 800_000, status: :available } })

    # Assert
    expect(response).to redirect_to(new_user_session_url)
  end

  it 'como usuário regular' do
    # Arrange
    user = User.create!(name: 'Pessoa', email: 'pessoa@sistemadefrete.com.br', password: 'password', role: :regular)

    so = ShippingOption.create!(name: 'Outra Entrega', min_distance: 60 , max_distance: 700, min_weight: 3000, max_weight: 55_000, 
                                delivery_fee: 3.50)
    
    # Act
    login_as user
    post(vehicles_path, params: { vehicle: { shipping_option: so, license_plate: 'AAA0000', brand: 'Peugeot', car_model: 'Partner CS', 
                                             manufacture_year: '2021', max_weight: 800_000} })

    # Assert
    expect(response).to redirect_to(root_url)
  end
end