require 'rails_helper'

describe 'Visitante procura por ondem de serviço' do
  it 'a partir da tela inicial' do
    # Arrange

    # Act
    visit root_path

    # Assert
    expect(page).to have_field 'código de rastreio'
    expect(page).to have_button 'Buscar'
  end

  it 'e encontra 1 pedido pendente' do
    # Arrange
    first_order = Order.create!(delivery_address: 'Rua das Oliveiras, 15', delivery_city: 'São Gonçalo', delivery_state: 'RJ', 
                                delivery_postal_code: '28200000', recipient: 'Marta Silva', recipient_cpf: '00000000000',
                                recipient_email: 'martae@email.com', recipient_phone_number: '00000000000', 
                                pick_up_address: 'Estrada do Porto, 70', pick_up_city: 'Santo André', pick_up_state: 'SP', 
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
    fill_in 'código de rastreio', with: second_order.tracking_code
    click_on 'Buscar'

    # Assert
    expect(page).to have_content "Resultado da Busca por #{second_order.tracking_code}"
    expect(page).to have_content "Status: Pendente"
    expect(page).to have_content "SKU: TV32P-SAMSUNG-XPTO90"
    expect(page).not_to have_content "SKU: TV40P-SAMSUNG-XPTO90"
    expect(page).to have_content 'Destinatário: Denise Silva'
    expect(page).not_to have_content 'Destinatário: Marta Silva'
    expect(page).to have_content 'Local de Entrega: Rua das Palmeiras, 13 - Rio de Janeiro - RJ'
    expect(page).not_to have_content 'Local de Entrega: Rua das Oliveiras, 15 - São Gonçalo - RJ'
  end

  it ' e não encontra o pedido' do
    # Arrange

    # Act
    visit root_path
    fill_in 'código de rastreio', with: ''
    click_on 'Buscar'

    # Assert
    expect(page).to have_content 'Não foi possível encontrar o pedido'
  end
end