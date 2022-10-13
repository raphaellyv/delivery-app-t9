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

      order = Order.create!(delivery_address: 'Rua das Palmeiras, 13', delivery_city: 'Rio de Janeiro', delivery_state: 'RJ', 
                            delivery_postal_code: '28200000', recipient: 'Denise Silva', recipient_cpf: '00000000000',
                            recipient_email: 'denise@email.com', recipient_phone_number: '2297523040', 
                            pick_up_address: 'Estrada do Porto, 70', pick_up_city: 'São Paulo', pick_up_state: 'SP', 
                            pick_up_postal_code: '30000000', sku: 'TV32P-SAMSUNG-XPTO90', height: 60, width: 40, length: 100, 
                            weight: 3_000, distance: 300, status: :en_route)

      so = ShippingOption.create!(name: 'Outra Entrega', min_distance: 60 , max_distance: 700, min_weight: 3000, max_weight: 55_000, 
                                  delivery_fee: 5.50)

      vehicle = Vehicle.create!(shipping_option: so, license_plate: 'AAA0000', brand: 'Peugeot', car_model: 'Partner CS', 
                                manufacture_year: '2021', max_weight: 800_000, status: :en_route)
      
      DetailedOrder.create!(order: order, shipping_option: so, total_price: 905.50, 
                                  estimated_delivery_date: Time.now + 24.hours, vehicle: vehicle)

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

      order = Order.create!(delivery_address: 'Rua das Palmeiras, 13', delivery_city: 'Rio de Janeiro', delivery_state: 'RJ', 
                            delivery_postal_code: '28200000', recipient: 'Denise Silva', recipient_cpf: '00000000000',
                            recipient_email: 'denise@email.com', recipient_phone_number: '2297523040', 
                            pick_up_address: 'Estrada do Porto, 70', pick_up_city: 'São Paulo', pick_up_state: 'SP', 
                            pick_up_postal_code: '30000000', sku: 'TV32P-SAMSUNG-XPTO90', height: 60, width: 40, length: 100, 
                            weight: 3_000, distance: 300, status: :en_route)

      so = ShippingOption.create!(name: 'Entrega Expressa', min_distance: 50 , max_distance: 600, min_weight: 1_000, max_weight: 50_000, 
                                  delivery_fee: 5.50, status: :enabled)

      vehicle = Vehicle.create!(shipping_option: so, license_plate: 'BBB0000', brand: 'Fiat', car_model: 'Partner TX', manufacture_year: '2020',
                                max_weight: 700_000, status: :en_route)

      DetailedOrder.create!(order: order, shipping_option: so, total_price: 905.50, 
                            estimated_delivery_date: Time.now + 24.hours, vehicle: vehicle)

      # Act
      login_as user
      visit root_path
      click_on 'Veículos'
      click_on 'BBB0000'

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