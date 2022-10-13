require 'rails_helper'

describe 'Visitante procura por ondem de serviço' do
  context 'como administrador' do
    it 'a partir da lista de veículos' do
      # Arrange
      admin = User.create!(name: 'Pessoa', email: 'pessoa@sistemadefrete.com.br', password: 'password', role: :admin)

      # Act
      login_as admin
      visit root_path
  
      # Assert
      within 'nav' do
        expect(page).to have_field 'digite a placa do veículo'
        expect(page).to have_button 'Buscar Veículo'
      end
    end

    it 'com sucesso' do
      # Arrange
      admin = User.create!(name: 'Pessoa', email: 'pessoa@sistemadefrete.com.br', password: 'password', role: :admin)

      so_a = ShippingOption.create!(name: 'Entrega Expressa', min_distance: 50 , max_distance: 600, min_weight: 1000, max_weight: 50_000, 
                                    delivery_fee: 5.50)

      so_b = ShippingOption.create!(name: 'Outra Entrega', min_distance: 60 , max_distance: 700, min_weight: 3000, max_weight: 55_000, 
                                    delivery_fee: 3.50)

      Vehicle.create!(shipping_option: so_a, license_plate: 'AAA0000', brand: 'Peugeot', car_model: 'Partner CS', manufacture_year: '2021',
                      max_weight: 800_000, status: :available)

      Vehicle.create!(shipping_option: so_b, license_plate: 'BBB0000', brand: 'Fiat', car_model: 'Partner TX', manufacture_year: '2020',
                      max_weight: 700_000, status: :maintenance)

      # Act
      login_as admin
      visit root_path
      fill_in 'digite a placa do veículo', with: 'AAA0000'
      click_on 'Buscar Veículo'
  
      # Assert
      expect(page).to have_content 'Resultado da Busca por AAA0000'
      expect(page).to have_content 'Placa'
      expect(page).to have_link 'AAA0000'
      expect(page).to have_content 'Marca'
      expect(page).to have_content 'Peugeot'
      expect(page).to have_content 'Modelo'
      expect(page).to have_content 'Partner CS'
      expect(page).to have_content 'Ano'
      expect(page).to have_content '2021'
      expect(page).to have_content 'Carga Máxima'
      expect(page).to have_content '800 kg'
      expect(page).to have_content 'Status'
      expect(page).to have_content 'Disponível'
    end

    it 'e não encontra veículos' do
      # Arrange
      admin = User.create!(name: 'Pessoa', email: 'pessoa@sistemadefrete.com.br', password: 'password', role: :admin)

      # Act
      login_as admin
      visit root_path
      fill_in 'digite a placa do veículo', with: 'AAA0000'
      click_on 'Buscar Veículo'
  
      # Assert
      expect(page).to have_content 'Resultado da Busca por AAA0000'
      expect(page).to have_content 'Não foram encontrados Veículos'
    end

    it 'com parte da placa' do
      # Arrange
      admin = User.create!(name: 'Pessoa', email: 'pessoa@sistemadefrete.com.br', password: 'password', role: :admin)

      so_a = ShippingOption.create!(name: 'Entrega Expressa', min_distance: 50 , max_distance: 600, min_weight: 1000, max_weight: 50_000, 
                                    delivery_fee: 5.50)

      so_b = ShippingOption.create!(name: 'Outra Entrega', min_distance: 60 , max_distance: 700, min_weight: 3000, max_weight: 55_000, 
                                    delivery_fee: 3.50)

      Vehicle.create!(shipping_option: so_a, license_plate: 'AAA0000', brand: 'Peugeot', car_model: 'Partner CS', manufacture_year: '2021',
                      max_weight: 800_000, status: :available)

      Vehicle.create!(shipping_option: so_b, license_plate: 'AAA0001', brand: 'Fiat', car_model: 'Partner TX', manufacture_year: '2020',
                      max_weight: 700_000, status: :maintenance)

      # Act
      login_as admin
      visit root_path
      fill_in 'digite a placa do veículo', with: 'AA0'
      click_on 'Buscar Veículo'
  
      # Assert
      expect(page).to have_content 'Resultado da Busca por AA0'
      expect(page).to have_content 'Placa'
      expect(page).to have_link 'AAA0000'
      expect(page).to have_link 'AAA0001'
      expect(page).to have_content 'Marca'
      expect(page).to have_content 'Peugeot'
      expect(page).to have_content 'Fiat'
      expect(page).to have_content 'Modelo'
      expect(page).to have_content 'Partner CS'
      expect(page).to have_content 'Partner TX'
      expect(page).to have_content 'Ano'
      expect(page).to have_content '2021'
      expect(page).to have_content '2020'
      expect(page).to have_content 'Carga Máxima'
      expect(page).to have_content '800 kg'
      expect(page).to have_content '700 kg'
      expect(page).to have_content 'Status'
      expect(page).to have_content 'Disponível'
      expect(page).to have_content 'Em Manutenção'
    end
  end
  context 'como usuário regular' do
    it 'com sucesso' do
      # Arrange
      user = User.create!(name: 'Pessoa', email: 'pessoa@sistemadefrete.com.br', password: 'password', role: :regular)

      so_a = ShippingOption.create!(name: 'Entrega Expressa', min_distance: 50 , max_distance: 600, min_weight: 1000, max_weight: 50_000, 
                                    delivery_fee: 5.50)

      so_b = ShippingOption.create!(name: 'Outra Entrega', min_distance: 60 , max_distance: 700, min_weight: 3000, max_weight: 55_000, 
                                    delivery_fee: 3.50)

      Vehicle.create!(shipping_option: so_a, license_plate: 'AAA0000', brand: 'Peugeot', car_model: 'Partner CS', manufacture_year: '2021',
                      max_weight: 800_000, status: :available)

      Vehicle.create!(shipping_option: so_b, license_plate: 'BBB0000', brand: 'Fiat', car_model: 'Partner TX', manufacture_year: '2020',
                      max_weight: 700_000, status: :maintenance)

      # Act
      login_as user
      visit root_path
      fill_in 'digite a placa do veículo', with: 'AAA0000'
      click_on 'Buscar Veículo'
  
      # Assert
      expect(page).to have_content 'Resultado da Busca por AAA0000'
      expect(page).to have_content 'Placa'
      expect(page).to have_link 'AAA0000'
      expect(page).to have_content 'Marca'
      expect(page).to have_content 'Peugeot'
      expect(page).to have_content 'Modelo'
      expect(page).to have_content 'Partner CS'
      expect(page).to have_content 'Ano'
      expect(page).to have_content '2021'
      expect(page).to have_content 'Carga Máxima'
      expect(page).to have_content '800 kg'
      expect(page).to have_content 'Status'
      expect(page).to have_content 'Disponível'
    end

    it 'e não encontra veículos' do
      # Arrange
      user = User.create!(name: 'Pessoa', email: 'pessoa@sistemadefrete.com.br', password: 'password', role: :regular)

      # Act
      login_as user
      visit root_path
      fill_in 'digite a placa do veículo', with: 'AAA0000'
      click_on 'Buscar Veículo'
  
      # Assert
      expect(page).to have_content 'Resultado da Busca por AAA0000'
      expect(page).to have_content 'Não foram encontrados Veículos'
    end

    it 'com parte da placa' do
      # Arrange
      user = User.create!(name: 'Pessoa', email: 'pessoa@sistemadefrete.com.br', password: 'password', role: :regular)

      so_a = ShippingOption.create!(name: 'Entrega Expressa', min_distance: 50 , max_distance: 600, min_weight: 1000, max_weight: 50_000, 
                                    delivery_fee: 5.50)

      so_b = ShippingOption.create!(name: 'Outra Entrega', min_distance: 60 , max_distance: 700, min_weight: 3000, max_weight: 55_000, 
                                    delivery_fee: 3.50)

      Vehicle.create!(shipping_option: so_a, license_plate: 'AAA0000', brand: 'Peugeot', car_model: 'Partner CS', manufacture_year: '2021',
                      max_weight: 800_000, status: :available)

      Vehicle.create!(shipping_option: so_b, license_plate: 'AAA0001', brand: 'Fiat', car_model: 'Partner TX', manufacture_year: '2020',
                      max_weight: 700_000, status: :maintenance)

      # Act
      login_as user
      visit root_path
      fill_in 'digite a placa do veículo', with: 'AA0'
      click_on 'Buscar Veículo'
  
      # Assert
      expect(page).to have_content 'Resultado da Busca por AA0'
      expect(page).to have_content 'Placa'
      expect(page).to have_link 'AAA0000'
      expect(page).to have_link 'AAA0001'
      expect(page).to have_content 'Marca'
      expect(page).to have_content 'Peugeot'
      expect(page).to have_content 'Fiat'
      expect(page).to have_content 'Modelo'
      expect(page).to have_content 'Partner CS'
      expect(page).to have_content 'Partner TX'
      expect(page).to have_content 'Ano'
      expect(page).to have_content '2021'
      expect(page).to have_content '2020'
      expect(page).to have_content 'Carga Máxima'
      expect(page).to have_content '800 kg'
      expect(page).to have_content '700 kg'
      expect(page).to have_content 'Status'
      expect(page).to have_content 'Disponível'
      expect(page).to have_content 'Em Manutenção'
    end
  end

  context 'e não está autenticado' do
    it 'pela página inicial' do
      # Arrange
  
      # Act
      visit root_path
  
      # Assert
      within 'nav' do
        expect(page).not_to have_field 'digite a placa do veículo'
        expect(page).not_to have_button 'Buscar Veículo'
      end
    end

    it 'pela URL' do
      # Arrange
      so_a = ShippingOption.create!(name: 'Entrega Expressa', min_distance: 50 , max_distance: 600, min_weight: 1000, max_weight: 50_000, 
                                    delivery_fee: 5.50)

      so_b = ShippingOption.create!(name: 'Outra Entrega', min_distance: 60 , max_distance: 700, min_weight: 3000, max_weight: 55_000, 
                                    delivery_fee: 3.50)

      Vehicle.create!(shipping_option: so_a, license_plate: 'AAA0000', brand: 'Peugeot', car_model: 'Partner CS', manufacture_year: '2021',
                      max_weight: 800_000, status: :available)

      # Act
      visit search_vehicles_path
  
      # Assert
      expect(current_path).to eq new_user_session_path
    end
  end
end