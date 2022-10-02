require 'rails_helper'

describe 'Admin vê ordens de serviço' do
  it 'e deve estar autenticado' do
    # Arrange
    
    # Act
    visit root_path

    # Assert
    expect(page).not_to have_link 'Ordens de Serviço'
  end

  it 'com sucesso' do
    # Arrange
    user = User.create!(name: 'Pessoa', email: 'pessoa@sistemadefrete.com.br', password: 'password', role: :admin)

    order = Order.create!(delivery_address: 'Rua das Palmeiras, 13', delivery_city: 'Rio de Janeiro', delivery_state: 'RJ', 
                          delivery_postal_code: '28200000', recipient: 'Denise Silva', recipient_cpf: '00000000000',
                          recipient_email: 'denise@email.com', recipient_phone_number: '00000000000', 
                          pick_up_address: 'Estrada do Porto, 70', pick_up_city: 'São Paulo', pick_up_state: 'SP', 
                          pick_up_postal_code: '30000000', sku: '00000000000000000000', height: 60, width: 40, length: 100, 
                          weight: 300, distance: 6_000)

    # Act
    login_as user
    visit root_path
    within 'nav' do
      click_on 'Ordens de Serviço'
    end

    # Assert
    expect(current_path).to eq orders_path
    within 'main' do
      expect(page).to have_content 'Ordens de Serviço'
    end
    expect(page).to have_content 'Status'
    expect(page).to have_content 'Pendente'
    expect(page).to have_content 'Código de Rastreio'
    expect(page).to have_content order.tracking_code
    expect(page).to have_content 'Distância'
    expect(page).to have_content '6.000 km'
    expect(page).to have_content 'Origem'
    expect(page).to have_content 'São Paulo - SP'
    expect(page).to have_content 'Destino'
    expect(page).to have_content 'Rio de Janeiro - RJ'
  end
end