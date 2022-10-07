require 'rails_helper'

describe 'Usuário vê lista de veículos' do
  context 'como administrador' do
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
      
      Vehicle.create!(shipping_option: so_b, license_plate: 'BBB0003', brand: 'Fiat', car_model: 'Partner TX', manufacture_year: '2020',
                        max_weight: 700_000, status: :en_route)

      # Act
      login_as admin
      visit root_path
      within 'nav' do
        click_on 'Veículos'
      end

      # Assert
      within 'main' do
        expect(page).to have_content 'Veículos'
      end
      expect(page).to have_content 'Modalidade de Transporte'
      expect(page).to have_link 'Entrega Expressa'
      expect(page).to have_link 'Outra Entrega'
      expect(page).to have_content 'Placa'
      expect(page).to have_content 'AAA0000'
      expect(page).to have_content 'BBB0000'
      expect(page).to have_content 'Marca'
      expect(page).to have_content 'Peugeot'
      expect(page).to have_content 'Fiat'
      expect(page).to have_content 'Modelo'
      expect(page).to have_content 'Partner CS'
      expect(page).to have_content 'Partner TX'
      expect(page).to have_content 'Ano'
      expect(page).to have_content '2020'
      expect(page).to have_content '2021'
      expect(page).to have_content 'Carga Máxima'
      expect(page).to have_content '700 kg'
      expect(page).to have_content '800 kg'
      expect(page).to have_content 'Status'
      expect(page).to have_content 'Disponível'
    end

    it 'e não existem veículos cadastrados' do
      # Arrange
      admin = User.create!(name: 'Pessoa', email: 'pessoa@sistemadefrete.com.br', password: 'password', role: :admin)

      # Act
      login_as admin
      visit root_path
      within 'nav' do
        click_on 'Veículos'
      end

      # Assert
      expect(page).to have_content 'Não existem veículos cadastrados'
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
      
      Vehicle.create!(shipping_option: so_b, license_plate: 'BBB0003', brand: 'Fiat', car_model: 'Partner TX', manufacture_year: '2020',
                        max_weight: 700_000, status: :en_route)

      # Act
      login_as user
      visit root_path
      within 'nav' do
        click_on 'Veículos'
      end

      # Assert
      within 'main' do
        expect(page).to have_content 'Veículos'
      end
      expect(page).to have_content 'Modalidade de Transporte'
      expect(page).to have_link 'Entrega Expressa'
      expect(page).to have_link 'Outra Entrega'
      expect(page).to have_content 'Placa'
      expect(page).to have_content 'AAA0000'
      expect(page).to have_content 'BBB0000'
      expect(page).to have_content 'Marca'
      expect(page).to have_content 'Peugeot'
      expect(page).to have_content 'Fiat'
      expect(page).to have_content 'Modelo'
      expect(page).to have_content 'Partner CS'
      expect(page).to have_content 'Partner TX'
      expect(page).to have_content 'Ano'
      expect(page).to have_content '2020'
      expect(page).to have_content '2021'
      expect(page).to have_content 'Carga Máxima'
      expect(page).to have_content '700 kg'
      expect(page).to have_content '800 kg'
      expect(page).to have_content 'Status'
      expect(page).to have_content 'Disponível'
    end

    it 'e não existem veículos cadastrados' do
      # Arrange
      user = User.create!(name: 'Pessoa', email: 'pessoa@sistemadefrete.com.br', password: 'password', role: :regular)

      # Act
      login_as user
      visit root_path
      within 'nav' do
        click_on 'Veículos'
      end

      # Assert
      expect(page).to have_content 'Não existem veículos cadastrados'
    end
  end

  context 'e não está autenticado' do
    it 'pelo menu' do
      # Arrange

      # Act
      visit root_path

      # Assert
      expect(page).not_to have_content 'Veículos'
    end

    it 'pela url' do
      # Arrange

      # Act
      visit vehicles_path

      # Assert
      expect(current_path).to eq new_user_session_path
    end
  end
end