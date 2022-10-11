require 'rails_helper'

describe 'Usuário escolhe a modalidade de transporte para uma ordem de serviço pendente' do
  context 'como usuário regular' do
    it 'a partir da tela de detalhes' do
      # Arrange
      user = User.create!(name: 'Pessoa', email: 'pessoa@sistemadefrete.com.br', password: 'password', role: :regular)
    
      order = Order.create!(delivery_address: 'Rua das Palmeiras, 13', delivery_city: 'Rio de Janeiro', delivery_state: 'RJ', 
                            delivery_postal_code: '28200000', recipient: 'Denise Silva', recipient_cpf: '00000000000',
                            recipient_email: 'denise@email.com', recipient_phone_number: '2297523040', 
                            pick_up_address: 'Estrada do Porto, 70', pick_up_city: 'São Paulo', pick_up_state: 'SP', 
                            pick_up_postal_code: '30000000', sku: 'TV32P-SAMSUNG-XPTO90', height: 60, width: 40, length: 100, 
                            weight: 3_000, distance: 300, status: :pending)

      so_a = ShippingOption.create!(name: 'Entrega Expressa', min_distance: 50 , max_distance: 600, min_weight: 1_000, max_weight: 50_000, 
                                    delivery_fee: 5.50, status: :enabled)
                              
      Price.create!(min_weight: 2_001, max_weight: 4_000, price_per_km: 1.00, shipping_option: so_a)                         
      Deadline.create!(min_distance: 201, max_distance: 400, deadline: 48, shipping_option: so_a)
                              
      so_b = ShippingOption.create!(name: 'Entrega Básica', min_distance: 30 , max_distance: 800, min_weight: 1_500, max_weight: 40_000, 
                                    delivery_fee: 3.00, status: :enabled)
                              
      Price.create!(min_weight: 3_000, max_weight: 4_000, price_per_km: 1.50, shipping_option: so_b)                         
      Deadline.create!(min_distance: 300, max_distance: 400, deadline: 40, shipping_option: so_b)
  
      # Act
      login_as user
      visit root_path
      click_on 'Ordens de Serviço'
      click_on order.tracking_code
      click_on 'Selecionar Modalidade de Transporte'
  
      # Assert
      expect(page).to have_content "Ordem de Serviço #{order.tracking_code}"
      expect(page).to have_content 'Entrega Expressa'
      expect(page).to have_content 'Entrega Básica'
      expect(page).to have_content '48 h'
      expect(page).to have_content '40 h'
      expect(page).to have_content 'R$ 305,50'
      expect(page).to have_content 'R$ 453,00'
      expect(page).to have_button 'Selecionar Modalidade de Transporte'
    end

    it 'com sucesso' do
      # Arrange
      user = User.create!(name: 'Pessoa', email: 'pessoa@sistemadefrete.com.br', password: 'password', role: :regular)
    
      order = Order.create!(delivery_address: 'Rua das Palmeiras, 13', delivery_city: 'Rio de Janeiro', delivery_state: 'RJ', 
                            delivery_postal_code: '28200000', recipient: 'Denise Silva', recipient_cpf: '00000000000',
                            recipient_email: 'denise@email.com', recipient_phone_number: '2297523040', 
                            pick_up_address: 'Estrada do Porto, 70', pick_up_city: 'São Paulo', pick_up_state: 'SP', 
                            pick_up_postal_code: '30000000', sku: 'TV32P-SAMSUNG-XPTO90', height: 60, width: 40, length: 100, 
                            weight: 3_000, distance: 300, status: :pending)
    
      so_a = ShippingOption.create!(name: 'Entrega Expressa', min_distance: 50 , max_distance: 600, min_weight: 1_000, max_weight: 50_000, 
                                    delivery_fee: 5.50, status: :enabled)
    
      Price.create!(min_weight: 2_001, max_weight: 4_000, price_per_km: 1.00, shipping_option: so_a)
      Deadline.create!(min_distance: 201, max_distance: 400, deadline: 48, shipping_option: so_a)
    
      so_b = ShippingOption.create!(name: 'Entrega Básica', min_distance: 30 , max_distance: 800, min_weight: 1_500, max_weight: 40_000, 
                                    delivery_fee: 3.00, status: :enabled)
    
      Price.create!(min_weight: 3_000, max_weight: 4_000, price_per_km: 1.50, shipping_option: so_b)    
      Deadline.create!(min_distance: 300, max_distance: 400, deadline: 40, shipping_option: so_b)

      vehicle_a = Vehicle.create!(shipping_option: so_a, license_plate: 'AAA0000', brand: 'Peugeot', car_model: 'Partner CS', manufacture_year: '2021',
                                  max_weight: 800_000, status: :available)

      vehicle_b = Vehicle.create!(shipping_option: so_b, license_plate: 'BBB0000', brand: 'Fiat', car_model: 'Partner TX', manufacture_year: '2020',
                                  max_weight: 700_000, status: :available)

      vehicle_bb = Vehicle.create!(shipping_option: so_b, license_plate: 'BBB0003', brand: 'Fiat', car_model: 'Partner TX', manufacture_year: '2020',
                                   max_weight: 700_000, status: :en_route)
  
      # Act
      login_as user
      visit root_path
      click_on 'Ordens de Serviço'
      click_on order.tracking_code
      click_on 'Selecionar Modalidade de Transporte'
      select 'Entrega Básica', from: 'Modalidade de Transporte'
      click_on 'Selecionar Modalidade de Transporte'      
  
      # Assert
      expect(current_path).to eq order_path(order.id)
      expect(page).to have_content 'Modalidade de Transporte adicionada com sucesso'
      expect(page).not_to have_link 'Selecionar Modalidade de Transporte'
      expect(page).to have_content 'Detalhes da Entrega'
      expect(page).to have_content 'Status: Encaminhada'
      expect(page).to have_content 'Modalidade de Transporte: Entrega Básica'
      expect(page).to have_content 'Preço Total: R$ 453,00'
      expect(page).to have_content "Previsão de Entrega: #{ (Time.now + 40.hours).strftime("%d/%m/%Y") }"
      expect(page).to have_content "Veículo"
      expect(page).to have_content "Placa"
      expect(page).to have_content "Marca"
      expect(page).to have_content "Modelo"
      expect(page).to have_content "BBB0000"
      expect(page).to have_content "Fiat"
      expect(page).to have_content "Partner TX"
      expect(order.vehicle.status).to eq 'en_route'
    end

    it 'e não existem veículos disponíveis' do
      # Arrange
      user = User.create!(name: 'Pessoa', email: 'pessoa@sistemadefrete.com.br', password: 'password', role: :regular)
    
      order = Order.create!(delivery_address: 'Rua das Palmeiras, 13', delivery_city: 'Rio de Janeiro', delivery_state: 'RJ', 
                            delivery_postal_code: '28200000', recipient: 'Denise Silva', recipient_cpf: '00000000000',
                            recipient_email: 'denise@email.com', recipient_phone_number: '2297523040', 
                            pick_up_address: 'Estrada do Porto, 70', pick_up_city: 'São Paulo', pick_up_state: 'SP', 
                            pick_up_postal_code: '30000000', sku: 'TV32P-SAMSUNG-XPTO90', height: 60, width: 40, length: 100, 
                            weight: 3_000, distance: 300, status: :pending)

      so_b = ShippingOption.create!(name: 'Entrega Básica', min_distance: 30 , max_distance: 800, min_weight: 1_500, max_weight: 40_000, 
                                    delivery_fee: 3.00, status: :enabled)
    
      Price.create!(min_weight: 3_000, max_weight: 4_000, price_per_km: 1.50, shipping_option: so_b)    
      Deadline.create!(min_distance: 300, max_distance: 400, deadline: 40, shipping_option: so_b)

      # Act
      login_as user
      visit root_path
      click_on 'Ordens de Serviço'
      click_on order.tracking_code
      click_on 'Selecionar Modalidade de Transporte'
      select 'Entrega Básica', from: 'Modalidade de Transporte'
      click_on 'Selecionar Modalidade de Transporte'      
  
      # Assert
      expect(current_path).to eq new_order_detailed_order_path(order.id)
      expect(page).to have_content 'No momento não existem veículos disponíveis para esta Modalidade de Transporte'
    end
  end

  context 'como usuário administrador' do
    it 'com sucesso' do
      # Arrange
      admin = User.create!(name: 'Pessoa', email: 'pessoa@sistemadefrete.com.br', password: 'password', role: :admin)
    
      order = Order.create!(delivery_address: 'Rua das Palmeiras, 13', delivery_city: 'Rio de Janeiro', delivery_state: 'RJ', 
                            delivery_postal_code: '28200000', recipient: 'Denise Silva', recipient_cpf: '00000000000',
                            recipient_email: 'denise@email.com', recipient_phone_number: '2297523040', 
                            pick_up_address: 'Estrada do Porto, 70', pick_up_city: 'São Paulo', pick_up_state: 'SP', 
                            pick_up_postal_code: '30000000', sku: 'TV32P-SAMSUNG-XPTO90', height: 60, width: 40, length: 100, 
                            weight: 3_000, distance: 300, status: :pending)
    
      so_a = ShippingOption.create!(name: 'Entrega Expressa', min_distance: 50 , max_distance: 600, min_weight: 1_000, max_weight: 50_000, 
                                    delivery_fee: 5.50, status: :enabled)
    
      Price.create!(min_weight: 2_001, max_weight: 4_000, price_per_km: 1.00, shipping_option: so_a)
      Deadline.create!(min_distance: 201, max_distance: 400, deadline: 48, shipping_option: so_a)
    
      so_b = ShippingOption.create!(name: 'Entrega Básica', min_distance: 30 , max_distance: 800, min_weight: 1_500, max_weight: 40_000, 
                                    delivery_fee: 3.00, status: :enabled)
    
      Price.create!(min_weight: 3_000, max_weight: 4_000, price_per_km: 1.50, shipping_option: so_b)    
      Deadline.create!(min_distance: 300, max_distance: 400, deadline: 40, shipping_option: so_b)

      vehicle_a = Vehicle.create!(shipping_option: so_a, license_plate: 'AAA0000', brand: 'Peugeot', car_model: 'Partner CS', manufacture_year: '2021',
                                  max_weight: 800_000, status: :available)

      vehicle_b = Vehicle.create!(shipping_option: so_b, license_plate: 'BBB0000', brand: 'Fiat', car_model: 'Partner TX', manufacture_year: '2020',
                                  max_weight: 700_000, status: :available)

      vehicle_bb = Vehicle.create!(shipping_option: so_b, license_plate: 'BBB0003', brand: 'Fiat', car_model: 'Partner TX', manufacture_year: '2020',
                                   max_weight: 700_000, status: :en_route)
  
      # Act
      login_as admin
      visit root_path
      click_on 'Ordens de Serviço'
      click_on order.tracking_code
      click_on 'Selecionar Modalidade de Transporte'
      select 'Entrega Básica', from: 'Modalidade de Transporte'
      click_on 'Selecionar Modalidade de Transporte'      
  
      # Assert
      expect(current_path).to eq order_path(order.id)
      expect(page).to have_content 'Modalidade de Transporte adicionada com sucesso'
      expect(page).not_to have_link 'Selecionar Modalidade de Transporte'
      expect(page).to have_content 'Detalhes da Entrega'
      expect(page).to have_content 'Status: Encaminhada'
      expect(page).to have_content 'Modalidade de Transporte: Entrega Básica'
      expect(page).to have_content 'Preço Total: R$ 453,00'
      expect(page).to have_content "Previsão de Entrega: #{ (Time.now + 40.hours).strftime("%d/%m/%Y") }"
      expect(page).to have_content "Veículo"
      expect(page).to have_content "Placa"
      expect(page).to have_content "Marca"
      expect(page).to have_content "Modelo"
      expect(page).to have_content "BBB0000"
      expect(page).to have_content "Fiat"
      expect(page).to have_content "Partner TX"
      expect(order.vehicle.status).to eq 'en_route'
    end

    it 'e não existem veículos disponíveis' do
      # Arrange
      admin = User.create!(name: 'Pessoa', email: 'pessoa@sistemadefrete.com.br', password: 'password', role: :admin)
    
      order = Order.create!(delivery_address: 'Rua das Palmeiras, 13', delivery_city: 'Rio de Janeiro', delivery_state: 'RJ', 
                            delivery_postal_code: '28200000', recipient: 'Denise Silva', recipient_cpf: '00000000000',
                            recipient_email: 'denise@email.com', recipient_phone_number: '2297523040', 
                            pick_up_address: 'Estrada do Porto, 70', pick_up_city: 'São Paulo', pick_up_state: 'SP', 
                            pick_up_postal_code: '30000000', sku: 'TV32P-SAMSUNG-XPTO90', height: 60, width: 40, length: 100, 
                            weight: 3_000, distance: 300, status: :pending)

      so_b = ShippingOption.create!(name: 'Entrega Básica', min_distance: 30 , max_distance: 800, min_weight: 1_500, max_weight: 40_000, 
                                    delivery_fee: 3.00, status: :enabled)
    
      Price.create!(min_weight: 3_000, max_weight: 4_000, price_per_km: 1.50, shipping_option: so_b)    
      Deadline.create!(min_distance: 300, max_distance: 400, deadline: 40, shipping_option: so_b)

      # Act
      login_as admin
      visit root_path
      click_on 'Ordens de Serviço'
      click_on order.tracking_code
      click_on 'Selecionar Modalidade de Transporte'
      select 'Entrega Básica', from: 'Modalidade de Transporte'
      click_on 'Selecionar Modalidade de Transporte'      
  
      # Assert
      expect(current_path).to eq new_order_detailed_order_path(order.id)
      expect(page).to have_content 'No momento não existem veículos disponíveis para esta Modalidade de Transporte'
    end
  end

  it 'e não está logado' do
    # Arrange
    order = Order.create!(delivery_address: 'Rua das Palmeiras, 13', delivery_city: 'Rio de Janeiro', delivery_state: 'RJ', 
                          delivery_postal_code: '28200000', recipient: 'Denise Silva', recipient_cpf: '00000000000',
                          recipient_email: 'denise@email.com', recipient_phone_number: '2297523040', 
                          pick_up_address: 'Estrada do Porto, 70', pick_up_city: 'São Paulo', pick_up_state: 'SP', 
                          pick_up_postal_code: '30000000', sku: 'TV32P-SAMSUNG-XPTO90', height: 60, width: 40, length: 100, 
                          weight: 3_000, distance: 300, status: :pending)

    # Act
    visit new_order_detailed_order_path(order.id)

    # Assert
    expect(current_path).to eq new_user_session_path
  end
end