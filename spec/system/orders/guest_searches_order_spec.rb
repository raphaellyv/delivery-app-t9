require 'rails_helper'

describe 'Visitante procura por ondem de serviço' do
  it 'a partir da tela inicial' do
    # Arrange

    # Act
    visit root_path

    # Assert
    expect(page).to have_field 'Código de Rastreio'
    expect(page).to have_button 'Buscar'
  end

  it 'e encontra 1 ordem pendente' do
    # Arrange
    first_order = Order.create!(delivery_address: 'Rua das Oliveiras, 15', delivery_city: 'São Gonçalo', delivery_state: 'RJ', 
                                delivery_postal_code: '28200000', recipient: 'Marta Silva', recipient_cpf: '00000000000',
                                recipient_email: 'martae@email.com', recipient_phone_number: '00000000000', 
                                pick_up_address: 'Estrada do Trem, 70', pick_up_city: 'Santo André', pick_up_state: 'SP', 
                                pick_up_postal_code: '30000000', sku: 'TV40P-SAMSUNG-XPTO90', height: 60, width: 40, length: 100, 
                                weight: 300, distance: 1_200)

    second_order = Order.create!(delivery_address: 'Rua das Palmeiras, 13', delivery_city: 'Rio de Janeiro', delivery_state: 'RJ', 
                                 delivery_postal_code: '28200000', recipient: 'Denise Silva', recipient_cpf: '00000000000',
                                 recipient_email: 'denise@email.com', recipient_phone_number: '2297523040', 
                                 pick_up_address: 'Estrada do Porto, 70', pick_up_city: 'São Paulo', pick_up_state: 'SP', 
                                 pick_up_postal_code: '30000000', sku: 'TV32P-SAMSUNG-XPTO90', height: 60, width: 40, length: 100, 
                                 weight: 3000, distance: 300, status: :pending)

    # Act
    visit root_path
    fill_in 'Código de Rastreio', with: second_order.tracking_code
    click_on 'Buscar'

    # Assert
    expect(page).to have_content "Resultado da Busca por #{second_order.tracking_code}"
    expect(page).to have_content "Status: Pendente"
    expect(page).to have_content 'Local de Entrega: Rua das Palmeiras, 13 - Rio de Janeiro - RJ'
    expect(page).not_to have_content 'Local de Entrega: Rua das Oliveiras, 15 - São Gonçalo - RJ'
    expect(page).to have_content 'Local de Retirada: Estrada do Porto, 70 - São Paulo - SP'
    expect(page).not_to have_content 'Local de Retirada: Estrada do Trem, 70 - Santo André - SP'
  end

  it 'e encontra uma ordem Encaminhada' do
    # Arrange
    order = Order.create!(delivery_address: 'Rua das Palmeiras, 13', delivery_city: 'Rio de Janeiro', delivery_state: 'RJ', 
                          delivery_postal_code: '28200000', recipient: 'Denise Silva', recipient_cpf: '00000000000',
                          recipient_email: 'denise@email.com', recipient_phone_number: '2297523040', 
                          pick_up_address: 'Estrada do Porto, 70', pick_up_city: 'São Paulo', pick_up_state: 'SP', 
                          pick_up_postal_code: '30000000', sku: 'TV32P-SAMSUNG-XPTO90', height: 60, width: 40, length: 100, 
                          weight: 3_000, distance: 300, status: :en_route)

    so = ShippingOption.create!(name: 'Entrega Expressa', min_distance: 50 , max_distance: 600, min_weight: 1_000, max_weight: 50_000, 
                                delivery_fee: 5.50, status: :enabled)

    vehicle = Vehicle.create!(shipping_option: so, license_plate: 'BBB0000', brand: 'Fiat', car_model: 'Partner TX', manufacture_year: '2020',
                              max_weight: 700_000)

    DetailedOrder.create!(order: order, shipping_option: so, total_price: 905.50, vehicle: vehicle, 
                          estimated_delivery_date: Date.tomorrow)
    
    # Act
    visit root_path
    fill_in 'Código de Rastreio', with: order.tracking_code
    click_on 'Buscar'

    # Assert
    expect(page).to have_content "Resultado da Busca por #{order.tracking_code}"
    expect(page).to have_content "Status: Encaminhada"
    expect(page).to have_content 'Local de Entrega: Rua das Palmeiras, 13 - Rio de Janeiro - RJ'
    expect(page).to have_content 'Local de Retirada: Estrada do Porto, 70 - São Paulo - SP'
    expect(page).to have_content 'Veículo'
    expect(page).to have_content 'Placa'
    expect(page).to have_content 'BBB0000'
    expect(page).to have_content 'Marca'
    expect(page).to have_content 'Fiat'
    expect(page).to have_content 'Modelo'
    expect(page).to have_content 'Partner TX'
    expect(page).to have_content 'Ano'
    expect(page).to have_content '2020'
    expect(page).to have_content "Previsão de Entrega: #{ Date.tomorrow.strftime("%d/%m/%Y") }"
  end

  it 'e encontra uma ordem Finalizada' do
    # Arrange
    order = Order.create!(delivery_address: 'Rua das Palmeiras, 13', delivery_city: 'Rio de Janeiro', delivery_state: 'RJ', 
                          delivery_postal_code: '28200000', recipient: 'Denise Silva', recipient_cpf: '00000000000',
                          recipient_email: 'denise@email.com', recipient_phone_number: '2297523040', 
                          pick_up_address: 'Estrada do Porto, 70', pick_up_city: 'São Paulo', pick_up_state: 'SP', 
                          pick_up_postal_code: '30000000', sku: 'TV32P-SAMSUNG-XPTO90', height: 60, width: 40, length: 100, 
                          weight: 3_000, distance: 300, status: :delivered_on_time)

    so = ShippingOption.create!(name: 'Entrega Expressa', min_distance: 50 , max_distance: 600, min_weight: 1_000, max_weight: 50_000, 
                                delivery_fee: 5.50, status: :enabled)

    vehicle = Vehicle.create!(shipping_option: so, license_plate: 'BBB0000', brand: 'Fiat', car_model: 'Partner TX', manufacture_year: '2020',
                              max_weight: 700_000)

    DetailedOrder.create!(order: order, shipping_option: so, total_price: 905.50, vehicle: vehicle, 
                          estimated_delivery_date: Date.tomorrow, delivery_date: Date.today)
    
    # Act
    visit root_path
    fill_in 'Código de Rastreio', with: order.tracking_code
    click_on 'Buscar'

    # Assert
    expect(page).to have_content "Resultado da Busca por #{order.tracking_code}"
    expect(page).to have_content "Status: Finalizada"
    expect(page).to have_content 'Local de Entrega: Rua das Palmeiras, 13 - Rio de Janeiro - RJ'
    expect(page).to have_content 'Local de Retirada: Estrada do Porto, 70 - São Paulo - SP'
    expect(page).to have_content 'Veículo'
    expect(page).to have_content 'Placa'
    expect(page).to have_content 'BBB0000'
    expect(page).to have_content 'Marca'
    expect(page).to have_content 'Fiat'
    expect(page).to have_content 'Modelo'
    expect(page).to have_content 'Partner TX'
    expect(page).to have_content 'Ano'
    expect(page).to have_content '2020'
    expect(page).to have_content "Previsão de Entrega: #{ Date.tomorrow.strftime("%d/%m/%Y") }"
    expect(page).to have_content "Data de Entrega: #{ Date.today.strftime("%d/%m/%Y") }"
  end

  it 'e encontra uma ordem Finalizada com Atraso' do
    # Arrange
    order = Order.create!(delivery_address: 'Rua das Palmeiras, 13', delivery_city: 'Rio de Janeiro', delivery_state: 'RJ', 
                          delivery_postal_code: '28200000', recipient: 'Denise Silva', recipient_cpf: '00000000000',
                          recipient_email: 'denise@email.com', recipient_phone_number: '2297523040', 
                          pick_up_address: 'Estrada do Porto, 70', pick_up_city: 'São Paulo', pick_up_state: 'SP', 
                          pick_up_postal_code: '30000000', sku: 'TV32P-SAMSUNG-XPTO90', height: 60, width: 40, length: 100, 
                          weight: 3_000, distance: 300, status: :delivered_late)

    so = ShippingOption.create!(name: 'Entrega Expressa', min_distance: 50 , max_distance: 600, min_weight: 1_000, max_weight: 50_000, 
                                delivery_fee: 5.50, status: :enabled)

    vehicle = Vehicle.create!(shipping_option: so, license_plate: 'BBB0000', brand: 'Fiat', car_model: 'Partner TX', manufacture_year: '2020',
                              max_weight: 700_000)

    DetailedOrder.create!(order: order, shipping_option: so, total_price: 905.50, vehicle: vehicle, 
                          estimated_delivery_date: Date.yesterday, delivery_date: Date.today)

    DelayedOrder.create!(order: order, cause_of_delay: 'Protestos na BR.')
    
    # Act
    visit root_path
    fill_in 'Código de Rastreio', with: order.tracking_code
    click_on 'Buscar'

    # Assert
    expect(page).to have_content "Resultado da Busca por #{order.tracking_code}"
    expect(page).to have_content "Status: Finalizada"
    expect(page).to have_content 'Local de Entrega: Rua das Palmeiras, 13 - Rio de Janeiro - RJ'
    expect(page).to have_content 'Local de Retirada: Estrada do Porto, 70 - São Paulo - SP'
    expect(page).to have_content 'Veículo'
    expect(page).to have_content 'Placa'
    expect(page).to have_content 'BBB0000'
    expect(page).to have_content 'Marca'
    expect(page).to have_content 'Fiat'
    expect(page).to have_content 'Modelo'
    expect(page).to have_content 'Partner TX'
    expect(page).to have_content 'Ano'
    expect(page).to have_content '2020'
    expect(page).to have_content "Previsão de Entrega: #{ Date.yesterday.strftime("%d/%m/%Y") }"
    expect(page).to have_content "Data de Entrega: #{ Date.today.strftime("%d/%m/%Y") }"
    expect(page).to have_content 'Motivo do Atraso'
    expect(page).to have_content 'Protestos na BR.'
  end

  it ' e não encontra a ordem' do
    # Arrange

    # Act
    visit root_path
    fill_in 'Código de Rastreio', with: ''
    click_on 'Buscar'

    # Assert
    expect(page).to have_content 'Não foi possível encontrar o pedido'
  end
end