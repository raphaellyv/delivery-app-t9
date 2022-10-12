require 'rails_helper'

describe 'Usuário vê orçamentos de ordens de serviço pendente' do
  context 'como usuário regular' do
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
  
      Price.create!(min_weight: 1_000, max_weight: 2_000, price_per_km: 3.00, shipping_option: so_a)
      Price.create!(min_weight: 2_001, max_weight: 4_000, price_per_km: 1.00, shipping_option: so_a)
  
      Deadline.create!(min_distance: 60, max_distance: 200, deadline: 30, shipping_option: so_a)
      Deadline.create!(min_distance: 201, max_distance: 400, deadline: 48, shipping_option: so_a)
  
      so_b = ShippingOption.create!(name: 'Entrega Básica', min_distance: 30 , max_distance: 800, min_weight: 1_500, max_weight: 40_000, 
                                    delivery_fee: 3.00, status: :enabled)
  
      Price.create!(min_weight: 1_500, max_weight: 2_000, price_per_km: 3.50, shipping_option: so_b)
      Price.create!(min_weight: 3_000, max_weight: 4_000, price_per_km: 1.50, shipping_option: so_b)
  
      Deadline.create!(min_distance: 60, max_distance: 200, deadline: 20, shipping_option: so_b)
      Deadline.create!(min_distance: 300, max_distance: 400, deadline: 40, shipping_option: so_b)

      so_c = ShippingOption.create!(name: 'Outra Entrega', min_distance: 30 , max_distance: 800, min_weight: 1_500, max_weight: 40_000, 
                                    delivery_fee: 3.00, status: :enabled)

      Price.create!(min_weight: 4_500, max_weight: 6_000, price_per_km: 3.50, shipping_option: so_c)
        
      Deadline.create!(min_distance: 40, max_distance: 600, deadline: 50, shipping_option: so_c)
          
      # Act
      login_as user
      visit root_path
      click_on 'Ordens de Serviço'
      click_on order.tracking_code
  
      # Assert
      expect(page).to have_content "Orçamento"
      within 'main' do
        expect(page).to have_content 'Modalidade'
        expect(page).to have_content 'Prazo'
        expect(page).to have_content 'Preço Total'
      end        
      expect(page).to have_content 'Entrega Expressa'
      expect(page).to have_content 'Entrega Básica'
      expect(page).not_to have_content 'Outra Entrega'
      expect(page).to have_content '48 h'
      expect(page).to have_content '40 h'
      expect(page).to have_content 'R$ 305,50'
      expect(page).to have_content 'R$ 453,00'
    end
      
    it 'e não existem intervalos de distância compatíveis' do
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
   
      Price.create!(min_weight: 1_000, max_weight: 4_000, price_per_km: 3.00, shipping_option: so_a)
   
      Deadline.create!(min_distance: 60, max_distance: 200, deadline: 30, shipping_option: so_a)
           
      # Act
      login_as user
      visit root_path
      click_on 'Ordens de Serviço'
      click_on order.tracking_code
   
      # Assert
      expect(page).to have_content "Orçamento"
      within 'main' do
        expect(page).not_to have_content 'Prazo'
        expect(page).not_to have_content 'Preço Total'
      end        
      expect(page).not_to have_content 'Entrega Expressa'
      expect(page).not_to have_content '30 h'
      expect(page).to have_content 'Não existem modalidades de transporte disponíveis para esta ordem de serviço'
    end

    it 'e não existem intervalos de peso compatíveis' do
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
   
      Price.create!(min_weight: 1_000, max_weight: 2_000, price_per_km: 3.00, shipping_option: so_a)
   
      Deadline.create!(min_distance: 60, max_distance: 400, deadline: 30, shipping_option: so_a)
           
      # Act
      login_as user
      visit root_path
      click_on 'Ordens de Serviço'
      click_on order.tracking_code
   
      # Assert
      expect(page).to have_content "Orçamento"
      within 'main' do
        expect(page).not_to have_content 'Prazo'
        expect(page).not_to have_content 'Preço Total'
      end        
      expect(page).not_to have_content 'Entrega Expressa'
      expect(page).to have_content 'Não existem modalidades de transporte disponíveis para esta ordem de serviço'
    end

    it 'e não existem modalidades de transporte disponíveis' do
      # Arrange
      user = User.create!(name: 'Pessoa', email: 'pessoa@sistemadefrete.com.br', password: 'password', role: :regular)
  
      order = Order.create!(delivery_address: 'Rua das Palmeiras, 13', delivery_city: 'Rio de Janeiro', delivery_state: 'RJ', 
                            delivery_postal_code: '28200000', recipient: 'Denise Silva', recipient_cpf: '00000000000',
                            recipient_email: 'denise@email.com', recipient_phone_number: '2297523040', 
                            pick_up_address: 'Estrada do Porto, 70', pick_up_city: 'São Paulo', pick_up_state: 'SP', 
                            pick_up_postal_code: '30000000', sku: 'TV32P-SAMSUNG-XPTO90', height: 60, width: 40, length: 100, 
                            weight: 3_000, distance: 300, status: :pending)
           
      # Act
      login_as user
      visit root_path
      click_on 'Ordens de Serviço'
      click_on order.tracking_code
   
      # Assert
      expect(page).to have_content "Orçamento"
      within 'main' do
        expect(page).not_to have_content 'Prazo'
        expect(page).not_to have_content 'Preço Total'
      end        
      expect(page).to have_content 'Não existem modalidades de transporte disponíveis para esta ordem de serviço'
    end

    it 'e a ordem de serviço não está pendente' do
      # Arrange
      user = User.create!(name: 'Pessoa', email: 'pessoa@sistemadefrete.com.br', password: 'password', role: :regular)
  
      order = Order.create!(delivery_address: 'Rua das Palmeiras, 13', delivery_city: 'Rio de Janeiro', delivery_state: 'RJ', 
                            delivery_postal_code: '28200000', recipient: 'Denise Silva', recipient_cpf: '00000000000',
                            recipient_email: 'denise@email.com', recipient_phone_number: '2297523040', 
                            pick_up_address: 'Estrada do Porto, 70', pick_up_city: 'São Paulo', pick_up_state: 'SP', 
                            pick_up_postal_code: '30000000', sku: 'TV32P-SAMSUNG-XPTO90', height: 60, width: 40, length: 100, 
                            weight: 3_000, distance: 300, status: :en_route)

      so_b = ShippingOption.create!(name: 'Entrega Básica', min_distance: 30 , max_distance: 800, min_weight: 1_500, max_weight: 40_000, 
                                    delivery_fee: 3.00, status: :enabled)

      vehicle_b = Vehicle.create!(shipping_option: so_b, license_plate: 'BBB0000', brand: 'Fiat', car_model: 'Partner TX', manufacture_year: '2020',
                                  max_weight: 700_000, status: :available)
      detailed_order = DetailedOrder.create!(order: order, shipping_option: so_b, total_price: 90.00, 
                                             estimated_delivery_date: Time.now + 40.hours, vehicle: vehicle_b)
           
      # Act
      login_as user
      visit root_path
      click_on 'Ordens de Serviço'
      click_on order.tracking_code
   
      # Assert
      expect(page).not_to have_content "Orçamento"
      expect(page).not_to have_content 'Não existem modalidades de transporte disponíveis para esta ordem de serviço'
    end
  end

  context 'como administrador' do
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

      Price.create!(min_weight: 1_000, max_weight: 2_000, price_per_km: 3.00, shipping_option: so_a)
      Price.create!(min_weight: 2_001, max_weight: 4_000, price_per_km: 1.00, shipping_option: so_a)

      Deadline.create!(min_distance: 60, max_distance: 200, deadline: 30, shipping_option: so_a)
      Deadline.create!(min_distance: 201, max_distance: 400, deadline: 48, shipping_option: so_a)

      so_b = ShippingOption.create!(name: 'Entrega Básica', min_distance: 30 , max_distance: 800, min_weight: 1_500, max_weight: 40_000, 
                                      delivery_fee: 3.00, status: :enabled)

      Price.create!(min_weight: 1_500, max_weight: 2_000, price_per_km: 3.50, shipping_option: so_b)
      Price.create!(min_weight: 3_000, max_weight: 4_000, price_per_km: 1.50, shipping_option: so_b)

      Deadline.create!(min_distance: 60, max_distance: 200, deadline: 20, shipping_option: so_b)
      Deadline.create!(min_distance: 300, max_distance: 400, deadline: 40, shipping_option: so_b)

      so_c = ShippingOption.create!(name: 'Outra Entrega', min_distance: 30 , max_distance: 800, min_weight: 1_500, max_weight: 40_000, 
                                    delivery_fee: 3.00, status: :enabled)

      Price.create!(min_weight: 4_500, max_weight: 6_000, price_per_km: 3.50, shipping_option: so_c)
      
      Deadline.create!(min_distance: 40, max_distance: 600, deadline: 50, shipping_option: so_c)
        
      # Act
      login_as admin
      visit root_path
      click_on 'Ordens de Serviço'
      click_on order.tracking_code

      # Assert
      expect(page).to have_content "Orçamento"
      within 'main' do
        expect(page).to have_content 'Modalidade'
        expect(page).to have_content 'Prazo'
        expect(page).to have_content 'Preço Total'
      end        
      expect(page).to have_content 'Entrega Expressa'
      expect(page).to have_content 'Entrega Básica'
      expect(page).not_to have_content 'Outra Entrega'
      expect(page).to have_content '48 h'
      expect(page).to have_content '40 h'
      expect(page).to have_content 'R$ 305,50'
      expect(page).to have_content 'R$ 453,00'
    end
    
    it 'e não existem intervalos de distância compatíveis' do
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
 
      Price.create!(min_weight: 1_000, max_weight: 4_000, price_per_km: 3.00, shipping_option: so_a)
 
      Deadline.create!(min_distance: 60, max_distance: 200, deadline: 30, shipping_option: so_a)
         
      # Act
      login_as admin
      visit root_path
      click_on 'Ordens de Serviço'
      click_on order.tracking_code
 
      # Assert
      expect(page).to have_content "Orçamento"
      within 'main' do
        expect(page).not_to have_content 'Prazo'
        expect(page).not_to have_content 'Preço Total'
      end        
      expect(page).not_to have_content 'Entrega Expressa'
      expect(page).not_to have_content '30 h'
      expect(page).to have_content 'Não existem modalidades de transporte disponíveis para esta ordem de serviço'
    end

    it 'e não existem intervalos de peso compatíveis' do
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
 
      Price.create!(min_weight: 1_000, max_weight: 2_000, price_per_km: 3.00, shipping_option: so_a)
 
      Deadline.create!(min_distance: 60, max_distance: 400, deadline: 30, shipping_option: so_a)
         
      # Act
      login_as admin
      visit root_path
      click_on 'Ordens de Serviço'
      click_on order.tracking_code
 
      # Assert
      expect(page).to have_content "Orçamento"
      within 'main' do
        expect(page).not_to have_content 'Prazo'
        expect(page).not_to have_content 'Preço Total'
      end        
      expect(page).not_to have_content 'Entrega Expressa'
      expect(page).to have_content 'Não existem modalidades de transporte disponíveis para esta ordem de serviço'
    end

    it 'e a modalidade de transporte está inativa' do
      # Arrange
      admin = User.create!(name: 'Pessoa', email: 'pessoa@sistemadefrete.com.br', password: 'password', role: :admin)

      order = Order.create!(delivery_address: 'Rua das Palmeiras, 13', delivery_city: 'Rio de Janeiro', delivery_state: 'RJ', 
                            delivery_postal_code: '28200000', recipient: 'Denise Silva', recipient_cpf: '00000000000',
                            recipient_email: 'denise@email.com', recipient_phone_number: '2297523040', 
                            pick_up_address: 'Estrada do Porto, 70', pick_up_city: 'São Paulo', pick_up_state: 'SP', 
                            pick_up_postal_code: '30000000', sku: 'TV32P-SAMSUNG-XPTO90', height: 60, width: 40, length: 100, 
                            weight: 3_000, distance: 300, status: :pending)

      so = ShippingOption.create!(name: 'Entrega Expressa', min_distance: 50 , max_distance: 600, min_weight: 1_000, max_weight: 50_000, 
                                  delivery_fee: 5.50, status: :disabled)

      Price.create!(min_weight: 2_001, max_weight: 4_000, price_per_km: 1.00, shipping_option: so)

      Deadline.create!(min_distance: 201, max_distance: 400, deadline: 48, shipping_option: so)

        
      # Act
      login_as admin
      visit root_path
      click_on 'Ordens de Serviço'
      click_on order.tracking_code

      # Assert
      expect(page).to have_content "Orçamento"
      within 'main' do
        expect(page).not_to have_content 'Prazo'
        expect(page).not_to have_content 'Preço Total'
      end        
      expect(page).not_to have_content 'Entrega Expressa'
      expect(page).to have_content 'Não existem modalidades de transporte disponíveis para esta ordem de serviço'
    end
  end
end
