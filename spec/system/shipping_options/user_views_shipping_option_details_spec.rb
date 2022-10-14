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

    it 'e vê os veículos da modalidade' do
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

    it 'e não existem veículos cadastrados para a modalidade' do
      # Arrange
      admin = User.create!(name: 'Pessoa', email: 'pessoa@sistemadefrete.com.br', password: 'password', role: :admin)
  
      so_a = ShippingOption.create!(name: 'Entrega Expressa', min_distance: 50 , max_distance: 600, min_weight: 1_000, max_weight: 800_000, 
                                    delivery_fee: 5.50, status: :enabled)

  
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
      expect(page).to have_content 'Não existem veículos cadastrados'
    end

    it 'e vê os preços cadastrados para a modalidade' do
      # Arrange
      admin = User.create!(name: 'Pessoa', email: 'pessoa@sistemadefrete.com.br', password: 'password', role: :admin)
  
      so_a = ShippingOption.create!(name: 'Entrega Expressa', min_distance: 50 , max_distance: 600, min_weight: 1_000, max_weight: 50_000, 
                                    delivery_fee: 5.50)

      so_b = ShippingOption.create!(name: 'Outra Entrega', min_distance: 60 , max_distance: 700, min_weight: 3_000, max_weight: 55_000, 
                                    delivery_fee: 3.50)

      Price.create!(min_weight: 3_000, max_weight: 10_000, price_per_km: 6.00, shipping_option: so_a)
      Price.create!(min_weight: 1_000, max_weight: 2_000, price_per_km: 4.00, shipping_option: so_a)

      Price.create!(min_weight: 4_000, max_weight: 10_000, price_per_km: 5.00, shipping_option: so_b)

      # Act
      login_as admin
      visit root_path
      click_on 'Modalidades de Transporte'
      click_on 'Entrega Expressa'
      
      # Assert
      expect(current_path).to eq shipping_option_path(so_a.id)
      within 'main' do
        expect(page).to have_content 'Preços'
      end
      expect(page).to have_content 'Modalidade de Transporte'
      expect(page).to have_link 'Entrega Expressa'
      expect(page).not_to have_link 'Outra Entrega'
      expect(page).to have_content 'Intervalo de Peso'
      expect(page).to have_content '3 kg a 10 kg'
      expect(page).to have_content '1 kg a 2 kg'
      expect(page).not_to have_content '4 kg a 10 kg'
      expect(page).to have_content 'Preço por km'
      expect(page).to have_content 'R$ 6,00'
      expect(page).to have_content 'R$ 4,00'
      expect(page).not_to have_content 'R$ 5,00'
    end

    it 'e não existem preços cadastrados para a modalidade' do
      # Arrange
      admin = User.create!(name: 'Pessoa', email: 'pessoa@sistemadefrete.com.br', password: 'password', role: :admin)
  
      so_a = ShippingOption.create!(name: 'Entrega Expressa', min_distance: 50 , max_distance: 600, min_weight: 1_000, max_weight: 50_000, 
                                    delivery_fee: 5.50)

      # Act
      login_as admin
      visit root_path
      click_on 'Modalidades de Transporte'
      click_on 'Entrega Expressa'
      
      # Assert
      expect(current_path).to eq shipping_option_path(so_a.id)
      within 'main' do
        expect(page).to have_content 'Preços'
      end
      expect(page).to have_content 'Não existem preços cadastrados'
    end

    it 'e vê os prazos cadastrados para a modalidade' do
      # Arrange
      admin = User.create!(name: 'Pessoa', email: 'pessoa@sistemadefrete.com.br', password: 'password', role: :admin)

      so_a = ShippingOption.create!(name: 'Entrega Expressa', min_distance: 50 , max_distance: 600, min_weight: 1000, max_weight: 50_000, 
                                    delivery_fee: 5.50)
      so_b = ShippingOption.create!(name: 'Outra Entrega', min_distance: 60 , max_distance: 700, min_weight: 3000, max_weight: 55_000, 
                                    delivery_fee: 3.50)

      Deadline.create!(min_distance: 101, max_distance: 500, deadline: 48, shipping_option: so_a)
      Deadline.create!(min_distance: 50, max_distance: 100, deadline: 24, shipping_option: so_a)

      Deadline.create!(min_distance: 70, max_distance: 100, deadline: 30, shipping_option: so_b)

      # Act
      login_as admin
      visit root_path
      click_on 'Modalidades de Transporte'
      click_on 'Entrega Expressa'
      
      # Assert
      within 'main' do
        expect(page).to have_content 'Prazos'
        expect(page).to have_content 'Prazo de Entrega'
      end
      expect(page).to have_content '48 h'
      expect(page).to have_content '24 h'
      expect(page).not_to have_content '30 h'
      expect(page).to have_content 'Intervalo de Distância'
      expect(page).not_to have_content '70 km a 100 km'
      expect(page).to have_content '50 km a 100 km'
      expect(page).to have_content '101 km a 500 km'
      expect(page).to have_content 'Modalidade de Transporte'
      expect(page).to have_link 'Entrega Expressa'
      expect(page).not_to have_link 'Outra Entrega'
    end

    it 'e não existem prazos cadastrados' do
      # Arrange
      admin = User.create!(name: 'Pessoa', email: 'pessoa@sistemadefrete.com.br', password: 'password', role: :admin)

      so_a = ShippingOption.create!(name: 'Entrega Expressa', min_distance: 50 , max_distance: 600, min_weight: 1000, max_weight: 50_000, 
                                    delivery_fee: 5.50)

      # Act
      login_as admin
      visit root_path
      click_on 'Modalidades de Transporte'
      click_on 'Entrega Expressa'
      
      # Assert
      within 'main' do
        expect(page).to have_content 'Prazos'
      end      
      expect(page).to have_content 'Não existem prazos de entrega cadastrados'
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

    it 'e não existem veículos cadastrados para a modalidade' do
      # Arrange
      user = User.create!(name: 'Pessoa', email: 'pessoa@sistemadefrete.com.br', password: 'password', role: :regular)
  
      so_a = ShippingOption.create!(name: 'Entrega Expressa', min_distance: 50 , max_distance: 600, min_weight: 1_000, max_weight: 800_000, 
                                    delivery_fee: 5.50, status: :enabled)
  
  
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
      expect(page).to have_content 'Não existem veículos cadastrados'
    end

    it 'e vê os preços cadastrados para a modalidade' do
      # Arrange
      user = User.create!(name: 'Pessoa', email: 'pessoa@sistemadefrete.com.br', password: 'password', role: :regular)
  
      so_a = ShippingOption.create!(name: 'Entrega Expressa', min_distance: 50 , max_distance: 600, min_weight: 1_000, max_weight: 50_000, 
                                    delivery_fee: 5.50)

      so_b = ShippingOption.create!(name: 'Outra Entrega', min_distance: 60 , max_distance: 700, min_weight: 3_000, max_weight: 55_000, 
                                    delivery_fee: 3.50)

      Price.create!(min_weight: 3_000, max_weight: 10_000, price_per_km: 6.00, shipping_option: so_a)
      Price.create!(min_weight: 1_000, max_weight: 2_000, price_per_km: 4.00, shipping_option: so_a)

      Price.create!(min_weight: 4_000, max_weight: 10_000, price_per_km: 5.00, shipping_option: so_b)

      # Act
      login_as user
      visit root_path
      click_on 'Modalidades de Transporte'
      click_on 'Entrega Expressa'
      
      # Assert
      expect(current_path).to eq shipping_option_path(so_a.id)
      within 'main' do
        expect(page).to have_content 'Preços'
      end
      expect(page).to have_content 'Modalidade de Transporte'
      expect(page).to have_link 'Entrega Expressa'
      expect(page).not_to have_link 'Outra Entrega'
      expect(page).to have_content 'Intervalo de Peso'
      expect(page).to have_content '3 kg a 10 kg'
      expect(page).to have_content '1 kg a 2 kg'
      expect(page).not_to have_content '4 kg a 10 kg'
      expect(page).to have_content 'Preço por km'
      expect(page).to have_content 'R$ 6,00'
      expect(page).to have_content 'R$ 4,00'
      expect(page).not_to have_content 'R$ 5,00'
    end

    it 'e não existem preços cadastrados para a modalidade' do
      # Arrange
      user = User.create!(name: 'Pessoa', email: 'pessoa@sistemadefrete.com.br', password: 'password', role: :regular)
  
      so_a = ShippingOption.create!(name: 'Entrega Expressa', min_distance: 50 , max_distance: 600, min_weight: 1_000, max_weight: 50_000, 
                                    delivery_fee: 5.50)

      # Act
      login_as user
      visit root_path
      click_on 'Modalidades de Transporte'
      click_on 'Entrega Expressa'
      
      # Assert
      expect(current_path).to eq shipping_option_path(so_a.id)
      within 'main' do
        expect(page).to have_content 'Preços'
      end
      expect(page).to have_content 'Não existem preços cadastrados'
    end

    it 'e vê os prazos cadastrados para a modalidade' do
      # Arrange
      user = User.create!(name: 'Pessoa', email: 'pessoa@sistemadefrete.com.br', password: 'password', role: :regular)

      so_a = ShippingOption.create!(name: 'Entrega Expressa', min_distance: 50 , max_distance: 600, min_weight: 1000, max_weight: 50_000, 
                                    delivery_fee: 5.50)
      so_b = ShippingOption.create!(name: 'Outra Entrega', min_distance: 60 , max_distance: 700, min_weight: 3000, max_weight: 55_000, 
                                    delivery_fee: 3.50)

      Deadline.create!(min_distance: 101, max_distance: 500, deadline: 48, shipping_option: so_a)
      Deadline.create!(min_distance: 50, max_distance: 100, deadline: 24, shipping_option: so_a)

      Deadline.create!(min_distance: 70, max_distance: 100, deadline: 30, shipping_option: so_b)

      # Act
      login_as user
      visit root_path
      click_on 'Modalidades de Transporte'
      click_on 'Entrega Expressa'
      
      # Assert
      within 'main' do
        expect(page).to have_content 'Prazos'
        expect(page).to have_content 'Prazo de Entrega'
      end
      expect(page).to have_content '48 h'
      expect(page).to have_content '24 h'
      expect(page).not_to have_content '30 h'
      expect(page).to have_content 'Intervalo de Distância'
      expect(page).not_to have_content '70 km a 100 km'
      expect(page).to have_content '50 km a 100 km'
      expect(page).to have_content '101 km a 500 km'
      expect(page).to have_content 'Modalidade de Transporte'
      expect(page).to have_link 'Entrega Expressa'
      expect(page).not_to have_link 'Outra Entrega'
    end

    it 'e não existem prazos cadastrados' do
      # Arrange
      user = User.create!(name: 'Pessoa', email: 'pessoa@sistemadefrete.com.br', password: 'password', role: :regular)

      so_a = ShippingOption.create!(name: 'Entrega Expressa', min_distance: 50 , max_distance: 600, min_weight: 1000, max_weight: 50_000, 
                                    delivery_fee: 5.50)

      # Act
      login_as user
      visit root_path
      click_on 'Modalidades de Transporte'
      click_on 'Entrega Expressa'
      
      # Assert
      within 'main' do
        expect(page).to have_content 'Prazos'
      end      
      expect(page).to have_content 'Não existem prazos de entrega cadastrados'
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