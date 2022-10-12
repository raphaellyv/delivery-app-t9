require 'rails_helper'

describe 'Usuário edita um veículo' do
  it 'e precisa estar autenticado' do
    # Arrange
    so = ShippingOption.create!(name: 'Outra Entrega', min_distance: 60 , max_distance: 700, min_weight: 3000, max_weight: 55_000, 
                                delivery_fee: 3.50)

    vehicle = Vehicle.create!(shipping_option: so, license_plate: 'AAA0000', brand: 'Peugeot', car_model: 'Partner CS', 
                              manufacture_year: '2021', max_weight: 800_000, status: :available)

    # Act
    visit edit_vehicle_path(vehicle.id)

    # Assert
    expect(current_path).to eq new_user_session_path
  end

  context 'como administrador' do
    it 'a partir da lista de veículos' do
      # Arrange
      admin = User.create!(name: 'Pessoa', email: 'pessoa@sistemadefrete.com.br', password: 'password', role: :admin)

      so = ShippingOption.create!(name: 'Outra Entrega', min_distance: 60 , max_distance: 700, min_weight: 3000, max_weight: 55_000, 
                                  delivery_fee: 3.50)

      Vehicle.create!(shipping_option: so, license_plate: 'AAA0000', brand: 'Peugeot', car_model: 'Partner CS', 
                      manufacture_year: '2021', max_weight: 800_000, status: :available)

      # Act
      login_as admin
      visit root_path
      click_on 'Veículos'
      click_on 'AAA0000'
      click_on 'Editar Veículo'

      # Assert
      expect(page).to have_content 'Editar Veículo'
      expect(page).to have_field 'Placa', with: 'AAA0000'
      expect(page).to have_field 'Marca', with: 'Peugeot'
      expect(page).to have_field 'Modelo', with: 'Partner CS'
      expect(page).to have_field 'Ano', with: '2021'
      expect(page).to have_field 'Carga Máxima', with: '800000'
      expect(page).to have_button 'Atualizar Veículo'
    end

    it 'com sucesso' do
      # Arrange
      admin = User.create!(name: 'Pessoa', email: 'pessoa@sistemadefrete.com.br', password: 'password', role: :admin)

      so_a = ShippingOption.create!(name: 'Outra Entrega', min_distance: 60 , max_distance: 700, min_weight: 3000, max_weight: 55_000, 
                                  delivery_fee: 3.50)

      so_b = ShippingOption.create!(name: 'Entrega Expressa', min_distance: 60 , max_distance: 700, min_weight: 3000, max_weight: 55_000, 
                                    delivery_fee: 3.50)

      vehicle = Vehicle.create!(shipping_option: so_a, license_plate: 'AAA0000', brand: 'Peugeot', car_model: 'Partner CS', 
                                manufacture_year: '2021', max_weight: 800_000, status: :available)

      # Act
      login_as admin
      visit root_path
      click_on 'Veículos'
      click_on 'AAA0000'
      click_on 'Editar Veículo'
      fill_in 'Placa', with: 'BBB0000'
      fill_in 'Marca', with: 'Fiat'
      fill_in 'Modelo', with: 'Partner TX'
      fill_in 'Ano', with: '2020'
      fill_in 'Carga Máxima', with: '600000'
      select 'Entrega Expressa', from: 'Modalidade de Transporte'
      click_on 'Atualizar Veículo'

      # Assert
      expect(current_path).to eq vehicle_path(vehicle.id)
      expect(page).to have_content 'Veículo atualizado com sucesso'
      expect(page).to have_content 'Veículo BBB0000'
      expect(page).to have_content 'Marca: Fiat'
      expect(page).to have_content 'Modelo: Partner TX'
      expect(page).to have_content 'Ano: 2020'
      expect(page).to have_content 'Carga Máxima: 600 kg'
      expect(page).to have_content 'Modalidade de Transporte: Entrega Expressa'
    end

    it 'com dados incompletos' do
      # Arrange
      admin = User.create!(name: 'Pessoa', email: 'pessoa@sistemadefrete.com.br', password: 'password', role: :admin)

      so_a = ShippingOption.create!(name: 'Outra Entrega', min_distance: 60 , max_distance: 700, min_weight: 3000, max_weight: 55_000, 
                                  delivery_fee: 3.50)

      vehicle = Vehicle.create!(shipping_option: so_a, license_plate: 'AAA0000', brand: 'Peugeot', car_model: 'Partner CS', 
                                manufacture_year: '2021', max_weight: 800_000, status: :available)

      # Act
      login_as admin
      visit root_path
      click_on 'Veículos'
      click_on 'AAA0000'
      click_on 'Editar Veículo'
      fill_in 'Placa', with: ''
      fill_in 'Marca', with: ''
      fill_in 'Modelo', with: ''
      fill_in 'Ano', with: ''
      fill_in 'Carga Máxima', with: ''
      select '', from: 'Modalidade de Transporte'
      click_on 'Atualizar Veículo'

      # Assert
      expect(page).to have_content 'Não foi possível atualizar o Veículo'
      expect(page).to have_content 'Placa não pode ficar em branco'
      expect(page).to have_content 'Marca não pode ficar em branco'
      expect(page).to have_content 'Modelo não pode ficar em branco'
      expect(page).to have_content 'Ano não pode ficar em branco'
      expect(page).to have_content 'Carga Máxima não pode ficar em branco'
    end
  end

  context 'como usuário regular' do
    it 'a partir da lista de veículos' do
      # Arrange
      user = User.create!(name: 'Pessoa', email: 'pessoa@sistemadefrete.com.br', password: 'password', role: :regular)

      so = ShippingOption.create!(name: 'Outra Entrega', min_distance: 60 , max_distance: 700, min_weight: 3000, max_weight: 55_000, 
                                  delivery_fee: 3.50)

      Vehicle.create!(shipping_option: so, license_plate: 'AAA0000', brand: 'Peugeot', car_model: 'Partner CS', 
                      manufacture_year: '2021', max_weight: 800_000, status: :available)

      # Act
      login_as user
      visit root_path
      click_on 'Veículos'
      click_on 'AAA0000'

      # Assert
      expect(page).not_to have_link 'Editar Veículo'
    end

    it 'pela URL' do
      # Arrange
      user = User.create!(name: 'Pessoa', email: 'pessoa@sistemadefrete.com.br', password: 'password', role: :regular)

      so = ShippingOption.create!(name: 'Outra Entrega', min_distance: 60 , max_distance: 700, min_weight: 3000, max_weight: 55_000, 
                                  delivery_fee: 3.50)

      vehicle = Vehicle.create!(shipping_option: so, license_plate: 'AAA0000', brand: 'Peugeot', car_model: 'Partner CS', 
                      manufacture_year: '2021', max_weight: 800_000, status: :available)

      # Act
      login_as user
      visit edit_vehicle_path(vehicle.id)

      # Assert
      expect(current_path).to eq root_path
      expect(page).to have_content 'Área restrita a administradores'
    end
  end
end