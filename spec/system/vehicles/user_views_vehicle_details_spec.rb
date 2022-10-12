require 'rails_helper'

describe 'Usuário vê detalhes de um veículo' do
  it 'e não está autenticado' do
    # Arrange
    so = ShippingOption.create!(name: 'Outra Entrega', min_distance: 60 , max_distance: 700, min_weight: 3000, max_weight: 55_000, 
                                delivery_fee: 3.50)

    vehicle = Vehicle.create!(shipping_option: so, license_plate: 'AAA0000', brand: 'Peugeot', car_model: 'Partner CS', 
                              manufacture_year: '2021', max_weight: 800_000, status: :available)

    # Act
    visit vehicle_path(vehicle.id)

    # Assert
    expect(current_path).to eq new_user_session_path
  end

  it 'como administrador' do
    # Arrange
    admin = User.create!(name: 'Pessoa', email: 'pessoa@sistemadefrete.com.br', password: 'password', role: :admin)

    so = ShippingOption.create!(name: 'Outra Entrega', min_distance: 60 , max_distance: 700, min_weight: 3000, max_weight: 55_000, 
                                delivery_fee: 3.50)

    vehicle = Vehicle.create!(shipping_option: so, license_plate: 'AAA0000', brand: 'Peugeot', car_model: 'Partner CS', 
                              manufacture_year: '2021', max_weight: 800_000, status: :available)

    # Act
    login_as admin
    visit root_path
    click_on 'Veículos'
    click_on 'AAA0000'

    # Assert
    expect(current_path).to eq vehicle_path(vehicle.id)
    expect(page).to have_content 'Veículo AAA0000'
    expect(page).to have_content 'Modalidade de Transporte: Outra Entrega'
    expect(page).to have_link 'Outra Entrega'
    expect(page).to have_content 'Marca: Peugeot'
    expect(page).to have_content 'Modelo: Partner CS'
    expect(page).to have_content 'Ano: 2021'
    expect(page).to have_content 'Carga Máxima: 800 kg'
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
    visit root_path
    click_on 'Veículos'
    click_on 'AAA0000'

    # Assert
    expect(current_path).to eq vehicle_path(vehicle.id)
    expect(page).to have_content 'Veículo AAA0000'
    expect(page).to have_content 'Modalidade de Transporte: Outra Entrega'
    expect(page).to have_link 'Outra Entrega'
    expect(page).to have_content 'Marca: Peugeot'
    expect(page).to have_content 'Modelo: Partner CS'
    expect(page).to have_content 'Ano: 2021'
    expect(page).to have_content 'Carga Máxima: 800 kg'
  end
end