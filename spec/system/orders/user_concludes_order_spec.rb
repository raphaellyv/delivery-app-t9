require 'rails_helper'

describe 'Usuário finaliza ordem de serviço' do
  context 'como usuário regular' do
    it 'com sucesso' do
      # Arrange
      user = User.create!(name: 'Pessoa', email: 'pessoa@sistemadefrete.com.br', password: 'password', role: :regular)
    
      order = Order.create!(delivery_address: 'Rua das Palmeiras, 13', delivery_city: 'Rio de Janeiro', delivery_state: 'RJ', 
                            delivery_postal_code: '28200000', recipient: 'Denise Silva', recipient_cpf: '00000000000',
                            recipient_email: 'denise@email.com', recipient_phone_number: '2297523040', 
                            pick_up_address: 'Estrada do Porto, 70', pick_up_city: 'São Paulo', pick_up_state: 'SP', 
                            pick_up_postal_code: '30000000', sku: 'TV32P-SAMSUNG-XPTO90', height: 60, width: 40, length: 100, 
                            weight: 3_000, distance: 300, status: :en_route)

      so = ShippingOption.create!(name: 'Entrega Expressa', min_distance: 50 , max_distance: 600, min_weight: 1_000, max_weight: 50_000, 
                                  delivery_fee: 5.50, status: :enabled)

      vehicle = Vehicle.create!(shipping_option: so, license_plate: 'BBB0000', brand: 'Fiat', car_model: 'Partner TX', manufacture_year: '2020',
                                max_weight: 700_000, status: :available)

      DetailedOrder.create!(order: order, shipping_option: so, total_price: 905.50, 
                            estimated_delivery_date: Time.now + 24.hours, vehicle: vehicle)
      
      # Act
      login_as user
      visit root_path
      click_on 'Ordens de Serviço'
      click_on order.tracking_code
      click_on 'Marcar como Entregue'

      # Assert
      expect(page).to have_content 'Ordem de Serviço finalizada com sucesso'
      expect(page).to have_content 'Status: Finalizada'
      expect(order.vehicle.status).to eq 'available'
      expect(page).to have_content "Data de Entrega: #{ (Time.now).strftime("%d/%m/%Y") }"
    end

    it 'e é redirecionado para preencher o motivo do atraso' do
      # Arrange
      user = User.create!(name: 'Pessoa', email: 'pessoa@sistemadefrete.com.br', password: 'password', role: :regular)
    
      order = Order.create!(delivery_address: 'Rua das Palmeiras, 13', delivery_city: 'Rio de Janeiro', delivery_state: 'RJ', 
                            delivery_postal_code: '28200000', recipient: 'Denise Silva', recipient_cpf: '00000000000',
                            recipient_email: 'denise@email.com', recipient_phone_number: '2297523040', 
                            pick_up_address: 'Estrada do Porto, 70', pick_up_city: 'São Paulo', pick_up_state: 'SP', 
                            pick_up_postal_code: '30000000', sku: 'TV32P-SAMSUNG-XPTO90', height: 60, width: 40, length: 100, 
                            weight: 3_000, distance: 300, status: :en_route)

      so = ShippingOption.create!(name: 'Entrega Expressa', min_distance: 50 , max_distance: 600, min_weight: 1_000, max_weight: 50_000, 
                                  delivery_fee: 5.50, status: :enabled)

      vehicle = Vehicle.create!(shipping_option: so, license_plate: 'BBB0000', brand: 'Fiat', car_model: 'Partner TX', manufacture_year: '2020',
                                max_weight: 700_000, status: :available)

      DetailedOrder.create!(order: order, shipping_option: so, total_price: 905.50, vehicle: vehicle,
                            estimated_delivery_date: Time.now - 24.hours)
   
      # Act
      login_as user
      visit root_path
      click_on 'Ordens de Serviço'
      click_on order.tracking_code
      click_on 'Marcar como Entregue'

      # Assert
      expect(page).to have_content 'Ordem de Serviço finalizada com atraso'
      expect(page).to have_content "Ordem de Serviço #{ order.tracking_code }"
      expect(page).to have_content 'Status: Finalizada com Atraso'
      expect(page).to have_content "Previsão de Entrega: #{ (Time.now - 24.hours).strftime("%d/%m/%Y") }"
      expect(page).to have_content "Data de Entrega: #{ Time.now.strftime("%d/%m/%Y") }"
      expect(page).to have_field 'Motivo do Atraso'
      expect(page).to have_button 'Salvar'  
    end

    it 'e preenche o motivo do atraso' do
      # Arrange
      user = User.create!(name: 'Pessoa', email: 'pessoa@sistemadefrete.com.br', password: 'password', role: :regular)
    
      order = Order.create!(delivery_address: 'Rua das Palmeiras, 13', delivery_city: 'Rio de Janeiro', delivery_state: 'RJ', 
                            delivery_postal_code: '28200000', recipient: 'Denise Silva', recipient_cpf: '00000000000',
                            recipient_email: 'denise@email.com', recipient_phone_number: '2297523040', 
                            pick_up_address: 'Estrada do Porto, 70', pick_up_city: 'São Paulo', pick_up_state: 'SP', 
                            pick_up_postal_code: '30000000', sku: 'TV32P-SAMSUNG-XPTO90', height: 60, width: 40, length: 100, 
                            weight: 3_000, distance: 300, status: :en_route)

      so = ShippingOption.create!(name: 'Entrega Expressa', min_distance: 50 , max_distance: 600, min_weight: 1_000, max_weight: 50_000, 
                                  delivery_fee: 5.50, status: :enabled)

      vehicle = Vehicle.create!(shipping_option: so, license_plate: 'BBB0000', brand: 'Fiat', car_model: 'Partner TX', manufacture_year: '2020',
                                max_weight: 700_000, status: :available)

      DetailedOrder.create!(order: order, shipping_option: so, total_price: 905.50, vehicle: vehicle,
                            estimated_delivery_date: Time.now - 24.hours)
   
      # Act
      login_as user
      visit root_path
      click_on 'Ordens de Serviço'
      click_on order.tracking_code
      click_on 'Marcar como Entregue'
      fill_in 'Motivo do Atraso', with: 'Protestos na BR.'
      click_on 'Salvar'

      # Assert
      expect(current_path).to eq order_path(order)
      expect(page).to have_content 'Motivo do Atraso adicionado com sucesso'
      expect(page).to have_content 'Status: Finalizada com Atraso'
      expect(page).to have_content "Previsão de Entrega: #{ (Time.now - 24.hours).strftime("%d/%m/%Y") }"
      expect(page).to have_content "Data de Entrega: #{ Time.now.strftime("%d/%m/%Y") }"
      expect(page).to have_content 'Motivo do Atraso'
      expect(page).to have_content 'Protestos na BR.'
    end
  end
end