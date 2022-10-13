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

  context 'como administrador' do
    it 'com sucesso' do
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

    it 'e o veículo está Em Entrega' do
      # Arrange
      admin = User.create!(name: 'Pessoa', email: 'pessoa@sistemadefrete.com.br', password: 'password', role: :admin)

      first_order = Order.create!(delivery_address: 'Rua das Oliveiras, 15', delivery_city: 'São Gonçalo', delivery_state: 'RJ', 
                                  delivery_postal_code: '28200000', recipient: 'Marta Silva', recipient_cpf: '00000000000',
                                  recipient_email: 'martae@email.com', recipient_phone_number: '00000000000', 
                                  pick_up_address: 'Estrada do Porto, 70', pick_up_city: 'Santo André', pick_up_state: 'SP', 
                                  pick_up_postal_code: '30000000', sku: 'TV32P-SAMSUNG-XPTO90', height: 60, width: 40, length: 100, 
                                  weight: 2_000, distance: 200, status: :delivered_on_time)
    
      second_order = Order.create!(delivery_address: 'Rua das Palmeiras, 13', delivery_city: 'Rio de Janeiro', delivery_state: 'RJ', 
                                   delivery_postal_code: '28200000', recipient: 'Denise Silva', recipient_cpf: '00000000000',
                                   recipient_email: 'denise@email.com', recipient_phone_number: '2297523040', 
                                   pick_up_address: 'Estrada do Porto, 70', pick_up_city: 'São Paulo', pick_up_state: 'SP', 
                                   pick_up_postal_code: '30000000', sku: 'TV32P-SAMSUNG-XPTO90', height: 60, width: 40, length: 100, 
                                   weight: 3_000, distance: 300, status: :en_route)

      so = ShippingOption.create!(name: 'Entrega Expressa', min_distance: 50 , max_distance: 600, min_weight: 1_000, max_weight: 50_000, 
                                  delivery_fee: 5.50, status: :enabled)

      vehicle = Vehicle.create!(shipping_option: so, license_plate: 'BBB0000', brand: 'Fiat', car_model: 'Partner TX', 
                                manufacture_year: '2020', max_weight: 700_000, status: :en_route)

      DetailedOrder.create!(order: first_order, shipping_option: so, total_price: 605.50, 
                            estimated_delivery_date: Time.now - 24.hours, delivery_date: Time.now - 20.hours, vehicle: vehicle)

      DetailedOrder.create!(order: second_order, shipping_option: so, total_price: 905.50, 
                            estimated_delivery_date: Time.now + 24.hours, vehicle: vehicle)

      # Act
      login_as admin
      visit root_path
      click_on 'Veículos'
      click_on 'BBB0000'

      # Assert
      expect(page).to have_content 'Veículo BBB0000'
      expect(page).to have_content 'Ordem de Serviço:'
      expect(page).not_to have_link first_order.tracking_code
      expect(page).to have_link second_order.tracking_code
    end
  end

  context 'como usuário regular' do
    it 'com sucesso' do
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

    it 'e o veículo está Em Entrega' do
      # Arrange
      user = User.create!(name: 'Pessoa', email: 'pessoa@sistemadefrete.com.br', password: 'password', role: :regular)

      first_order = Order.create!(delivery_address: 'Rua das Oliveiras, 15', delivery_city: 'São Gonçalo', delivery_state: 'RJ', 
                                  delivery_postal_code: '28200000', recipient: 'Marta Silva', recipient_cpf: '00000000000',
                                  recipient_email: 'martae@email.com', recipient_phone_number: '00000000000', 
                                  pick_up_address: 'Estrada do Porto, 70', pick_up_city: 'Santo André', pick_up_state: 'SP', 
                                  pick_up_postal_code: '30000000', sku: 'TV32P-SAMSUNG-XPTO90', height: 60, width: 40, length: 100, 
                                  weight: 2_000, distance: 200, status: :delivered_on_time)
    
      second_order = Order.create!(delivery_address: 'Rua das Palmeiras, 13', delivery_city: 'Rio de Janeiro', delivery_state: 'RJ', 
                                   delivery_postal_code: '28200000', recipient: 'Denise Silva', recipient_cpf: '00000000000',
                                   recipient_email: 'denise@email.com', recipient_phone_number: '2297523040', 
                                   pick_up_address: 'Estrada do Porto, 70', pick_up_city: 'São Paulo', pick_up_state: 'SP', 
                                   pick_up_postal_code: '30000000', sku: 'TV32P-SAMSUNG-XPTO90', height: 60, width: 40, length: 100, 
                                   weight: 3_000, distance: 300, status: :en_route)

      so = ShippingOption.create!(name: 'Entrega Expressa', min_distance: 50 , max_distance: 600, min_weight: 1_000, max_weight: 50_000, 
                                  delivery_fee: 5.50, status: :enabled)

      vehicle = Vehicle.create!(shipping_option: so, license_plate: 'BBB0000', brand: 'Fiat', car_model: 'Partner TX', 
                                manufacture_year: '2020', max_weight: 700_000, status: :en_route)

      DetailedOrder.create!(order: first_order, shipping_option: so, total_price: 605.50, 
                            estimated_delivery_date: Time.now - 24.hours, delivery_date: Time.now - 20.hours, vehicle: vehicle)

      DetailedOrder.create!(order: second_order, shipping_option: so, total_price: 905.50, 
                            estimated_delivery_date: Time.now + 24.hours, vehicle: vehicle)

      # Act
      login_as user
      visit root_path
      click_on 'Veículos'
      click_on 'BBB0000'

      # Assert
      expect(page).to have_content 'Veículo BBB0000'
      expect(page).to have_content 'Ordem de Serviço:'
      expect(page).not_to have_link first_order.tracking_code
      expect(page).to have_link second_order.tracking_code
    end
  end
end