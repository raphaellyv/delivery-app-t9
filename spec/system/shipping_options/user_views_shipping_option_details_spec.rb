require 'rails_helper'

describe 'Usuário vê detalhes de uma modalidade de transporte' do
  context 'como administrador' do
    it 'com sucesso' do
      # Arrange
      admin = User.create!(name: 'Pessoa', email: 'pessoa@sistemadefrete.com.br', password: 'password', role: :admin)
  
      so = ShippingOption.create!(name: 'Entrega Expressa', min_distance: 50 , max_distance: 600, min_weight: 1_000, max_weight: 50_000, 
                                  delivery_fee: 5.50, status: :enabled)
  
      # Act
      login_as admin
      visit root_path
      click_on 'Modalidades de Transporte'
      click_on 'Entrega Expressa'
  
      # Assert
      expect(current_path).to eq shipping_option_path(so.id)
      expect(page).to have_content 'Modalidade Entrega Expressa'
      expect(page).to have_content 'Status: Ativa'
      expect(page).to have_content 'Intervalo de Distância: 50 km a 600 km'
      expect(page).to have_content 'Intervalo de Peso: 1 kg a 50 kg'
      expect(page).to have_content 'Taxa Fixa de Entrega: R$ 5,50'
    end

    it 'e vê os veículos da modalidade de transporte' do
      # Arrange
      admin = User.create!(name: 'Pessoa', email: 'pessoa@sistemadefrete.com.br', password: 'password', role: :admin)
  
      so_a = ShippingOption.create!(name: 'Entrega Expressa', min_distance: 50 , max_distance: 600, min_weight: 1_000, max_weight: 800_000, 
                                    delivery_fee: 5.50, status: :enabled)

      so_b = ShippingOption.create!(name: 'Outra Entrega', min_distance: 50 , max_distance: 600, min_weight: 1_000, max_weight: 800_000, 
                                    delivery_fee: 3.50, status: :enabled)

      Vehicle.create!(shipping_option: so_a, license_plate: 'AAA0000', brand: 'Peugeot', car_model: 'Partner CS', manufacture_year: '2021',
                      max_weight: 800_000, status: :available)
              
      Vehicle.create!(shipping_option: so_a, license_plate: 'BBB0000', brand: 'Fiat', car_model: 'Partner TX', manufacture_year: '2020',
                      max_weight: 700_000, status: :maintenance)
      
      Vehicle.create!(shipping_option: so_b, license_plate: 'BBB0001', brand: 'Fiat', car_model: 'Partner TX', manufacture_year: '2020',
                      max_weight: 700_000, status: :maintenance)
  
      # Act
      login_as admin
      visit root_path
      click_on 'Modalidades de Transporte'
      click_on 'Entrega Expressa'
  
      # Assert
      expect(current_path).to eq shipping_option_path(so_a.id)
      within 'main' do
       expect(page).to have_content 'Veículos' 
      end
      expect(page).to have_content 'Placa'
      expect(page).to have_content 'AAA0000'
      expect(page).to have_content 'BBB0000'
      expect(page).not_to have_content 'BBB0001'
      expect(page).to have_content 'Marca'
      expect(page).to have_content 'Peugeot'
      expect(page).to have_content 'Fiat'
      expect(page).to have_content 'Modelo'
      expect(page).to have_content 'Partner CS'
      expect(page).to have_content 'Partner TX'
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

      so = ShippingOption.create!(name: 'Entrega Expressa', min_distance: 50 , max_distance: 600, min_weight: 1_000, max_weight: 50_000, 
                                  delivery_fee: 5.50, status: :enabled)

      # Act
      login_as user
      visit root_path
      click_on 'Modalidades de Transporte'
      click_on 'Entrega Expressa'

      # Assert
      expect(current_path).to eq shipping_option_path(so.id)
      expect(page).to have_content 'Modalidade Entrega Expressa'
      expect(page).to have_content 'Status: Ativa'
      expect(page).to have_content 'Intervalo de Distância: 50 km a 600 km'
      expect(page).to have_content 'Intervalo de Peso: 1 kg a 50 kg'
      expect(page).to have_content 'Taxa Fixa de Entrega: R$ 5,50'
    end

    it 'e vê os veículos da modalidade de transporte' do
      # Arrange
      user = User.create!(name: 'Pessoa', email: 'pessoa@sistemadefrete.com.br', password: 'password', role: :regular)
  
      so_a = ShippingOption.create!(name: 'Entrega Expressa', min_distance: 50 , max_distance: 600, min_weight: 1_000, max_weight: 800_000, 
                                    delivery_fee: 5.50, status: :enabled)

      so_b = ShippingOption.create!(name: 'Outra Entrega', min_distance: 50 , max_distance: 600, min_weight: 1_000, max_weight: 800_000, 
                                    delivery_fee: 3.50, status: :enabled)

      Vehicle.create!(shipping_option: so_a, license_plate: 'AAA0000', brand: 'Peugeot', car_model: 'Partner CS', manufacture_year: '2021',
                      max_weight: 800_000, status: :available)
              
      Vehicle.create!(shipping_option: so_a, license_plate: 'BBB0000', brand: 'Fiat', car_model: 'Partner TX', manufacture_year: '2020',
                      max_weight: 700_000, status: :maintenance)
      
      Vehicle.create!(shipping_option: so_b, license_plate: 'BBB0001', brand: 'Fiat', car_model: 'Partner TX', manufacture_year: '2020',
                      max_weight: 700_000, status: :maintenance)
  
      # Act
      login_as user
      visit root_path
      click_on 'Modalidades de Transporte'
      click_on 'Entrega Expressa'
  
      # Assert
      expect(current_path).to eq shipping_option_path(so_a.id)
      within 'main' do
       expect(page).to have_content 'Veículos' 
      end
      expect(page).to have_content 'Placa'
      expect(page).to have_content 'AAA0000'
      expect(page).to have_content 'BBB0000'
      expect(page).not_to have_content 'BBB0001'
      expect(page).to have_content 'Marca'
      expect(page).to have_content 'Peugeot'
      expect(page).to have_content 'Fiat'
      expect(page).to have_content 'Modelo'
      expect(page).to have_content 'Partner CS'
      expect(page).to have_content 'Partner TX'
      expect(page).to have_content 'Carga Máxima'
      expect(page).to have_content '800 kg'
      expect(page).to have_content '700 kg'
      expect(page).to have_content 'Status'
      expect(page).to have_content 'Disponível'
      expect(page).to have_content 'Em Manutenção'
    end
  end

  it 'e não está autenticado' do
    # Arrange
    so = ShippingOption.create!(name: 'Entrega Expressa', min_distance: 50 , max_distance: 600, min_weight: 1_000, max_weight: 50_000, 
                                delivery_fee: 5.50, status: :enabled)

    # Act
    visit shipping_option_path(so.id)

    # Assert
    expect(current_path).to eq new_user_session_path
  end
end