require 'rails_helper'

describe 'Usuário altera o status de um veículo' do
  context 'como administrador' do
    it 'a partir da lista de veículos' do
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
      expect(page).to have_button 'Alterar Status para Em Manutenção'
      expect(page).not_to have_button 'Disponível'
    end

    it 'de Em Entrega para Em Manutenção' do
      # Arrange
      admin = User.create!(name: 'Pessoa', email: 'pessoa@sistemadefrete.com.br', password: 'password', role: :admin)

      so = ShippingOption.create!(name: 'Outra Entrega', min_distance: 60 , max_distance: 700, min_weight: 3000, max_weight: 55_000, 
                                  delivery_fee: 3.50)

      vehicle = Vehicle.create!(shipping_option: so, license_plate: 'AAA0000', brand: 'Peugeot', car_model: 'Partner CS', 
                                manufacture_year: '2021', max_weight: 800_000, status: :en_route)

      # Act
      login_as admin
      visit root_path
      click_on 'Veículos'
      click_on 'AAA0000'
      click_on 'Alterar Status para Em Manutenção'

      # Assert
      expect(page).to have_content 'Veículo AAA0000'
      expect(page).to have_content 'Status alterado com sucesso'
      expect(page).to have_content 'Status: Em Manutenção'
      expect(page).not_to have_button 'Alterar Status para Em Manutenção'
      expect(page).to have_button 'Alterar Status para Disponível'
    end

    it 'de Disponível para Em Manutenção' do
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
      click_on 'Alterar Status para Em Manutenção'

      # Assert
      expect(page).to have_content 'Veículo AAA0000'
      expect(page).to have_content 'Status alterado com sucesso'
      expect(page).to have_content 'Status: Em Manutenção'
      expect(page).not_to have_button 'Alterar Status para Em Manutenção'
      expect(page).to have_button 'Alterar Status para Disponível'
    end

    it 'de Em Manutenção para Disponível' do
      # Arrange
      admin = User.create!(name: 'Pessoa', email: 'pessoa@sistemadefrete.com.br', password: 'password', role: :admin)

      so = ShippingOption.create!(name: 'Outra Entrega', min_distance: 60 , max_distance: 700, min_weight: 3000, max_weight: 55_000, 
                                  delivery_fee: 3.50)

      vehicle = Vehicle.create!(shipping_option: so, license_plate: 'AAA0000', brand: 'Peugeot', car_model: 'Partner CS', 
                                manufacture_year: '2021', max_weight: 800_000, status: :maintenance)

      # Act
      login_as admin
      visit root_path
      click_on 'Veículos'
      click_on 'AAA0000'
      click_on 'Alterar Status para Disponível'

      # Assert
      expect(page).to have_content 'Veículo AAA0000'
      expect(page).to have_content 'Status alterado com sucesso'
      expect(page).to have_content 'Status: Disponível'
      expect(page).to have_button 'Alterar Status para Em Manutenção'
      expect(page).not_to have_button 'Alterar Status para Disponível'
    end
  end

  context 'como usuário regular' do
    it 'de Em Entrega para Em Manutenção' do
      # Arrange
      user = User.create!(name: 'Pessoa', email: 'pessoa@sistemadefrete.com.br', password: 'password', role: :regular)

      so = ShippingOption.create!(name: 'Outra Entrega', min_distance: 60 , max_distance: 700, min_weight: 3000, max_weight: 55_000, 
                                  delivery_fee: 3.50)

      vehicle = Vehicle.create!(shipping_option: so, license_plate: 'AAA0000', brand: 'Peugeot', car_model: 'Partner CS', 
                                manufacture_year: '2021', max_weight: 800_000, status: :en_route)

      # Act
      login_as user
      visit root_path
      click_on 'Veículos'
      click_on 'AAA0000'

      # Assert
      expect(current_path).to eq vehicle_path(vehicle.id)
      expect(page).not_to have_button 'Alterar Status para Em Manutenção'
      expect(page).not_to have_button 'Disponível'
    end

    it 'de Disponível para Em Manutenção' do
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
      expect(page).not_to have_button 'Alterar Status para Em Manutenção'
      expect(page).not_to have_button 'Disponível'
    end

    it 'de Em Manutenção para Disponível' do
      # Arrange
      user = User.create!(name: 'Pessoa', email: 'pessoa@sistemadefrete.com.br', password: 'password', role: :regular)

      so = ShippingOption.create!(name: 'Outra Entrega', min_distance: 60 , max_distance: 700, min_weight: 3000, max_weight: 55_000, 
                                  delivery_fee: 3.50)

      vehicle = Vehicle.create!(shipping_option: so, license_plate: 'AAA0000', brand: 'Peugeot', car_model: 'Partner CS', 
                                manufacture_year: '2021', max_weight: 800_000, status: :maintenance)

      # Act
      login_as user
      visit root_path
      click_on 'Veículos'
      click_on 'AAA0000'

      # Assert
      expect(current_path).to eq vehicle_path(vehicle.id)
      expect(page).not_to have_button 'Alterar Status para Em Manutenção'
      expect(page).not_to have_button 'Disponível'
    end
  end
end