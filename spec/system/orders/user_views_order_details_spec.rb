require 'rails_helper'

describe 'Usuário vê detalhes da ordem de serviço' do
  it 'como administrador' do
    # Arrange
    admin = User.create!(name: 'Pessoa', email: 'pessoa@sistemadefrete.com.br', password: 'password', role: :admin)

    order = Order.create!(delivery_address: 'Rua das Palmeiras, 13', delivery_city: 'Rio de Janeiro', delivery_state: 'RJ', 
                          delivery_postal_code: '28200000', recipient: 'Denise Silva', recipient_cpf: '00000000000',
                          recipient_email: 'denise@email.com', recipient_phone_number: '2297523040', 
                          pick_up_address: 'Estrada do Porto, 70', pick_up_city: 'São Paulo', pick_up_state: 'SP', 
                          pick_up_postal_code: '30000000', sku: 'TV32P-SAMSUNG-XPTO90', height: 60, width: 40, length: 100, 
                          weight: 3000, distance: 300)

    # Act
    login_as admin
    visit root_path
    click_on 'Ordens de Serviço'
    find('div#all-tab-pane').click_on order.tracking_code

    # Assert
    expect(page).to have_content "Ordem de Serviço #{order.tracking_code}"
    expect(page).to have_content 'Status: Pendente'
    expect(page).to have_content 'Distância: 300 km'

    expect(page).to have_content 'Dados do Produto'
    expect(page).to have_content 'SKU: TV32P-SAMSUNG-XPTO90'
    expect(page).to have_content 'Dimensões: 100 cm x 40 cm x 60 cm'
    expect(page).to have_content 'Peso: 3 kg'

    expect(page).to have_content 'Dados do Destinatário'
    expect(page).to have_content 'Destinatário: Denise Silva'
    expect(page).to have_content 'CPF do Destinatário: 000.000.000-00'
    expect(page).to have_content 'E-mail do Destinatário: denise@email.com'
    expect(page).to have_content 'Telefone do Destinatário: (22) 9752-3040'
    
    expect(page).to have_content 'Dados para Retirada'
    expect(page).to have_content 'Local de Retirada: Estrada do Porto, 70 - São Paulo - SP'
    expect(page).to have_content 'CEP de Retirada: 30.000-000'

    expect(page).to have_content 'Dados para Entrega'
    expect(page).to have_content 'Local de Entrega: Rua das Palmeiras, 13 - Rio de Janeiro - RJ'
    expect(page).to have_content 'CEP de Entrega: 28.200-000' 
  end

  it 'como usuário regular' do
    # Arrange
    user = User.create!(name: 'Pessoa', email: 'pessoa@sistemadefrete.com.br', password: 'password', role: :regular)

    order = Order.create!(delivery_address: 'Rua das Palmeiras, 13', delivery_city: 'Rio de Janeiro', delivery_state: 'RJ', 
                          delivery_postal_code: '28200000', recipient: 'Denise Silva', recipient_cpf: '00000000000',
                          recipient_email: 'denise@email.com', recipient_phone_number: '2297523040', 
                          pick_up_address: 'Estrada do Porto, 70', pick_up_city: 'São Paulo', pick_up_state: 'SP', 
                          pick_up_postal_code: '30000000', sku: 'TV32P-SAMSUNG-XPTO90', height: 60, width: 40, length: 100, 
                          weight: 3000, distance: 300)

    # Act
    login_as user
    visit root_path
    click_on 'Ordens de Serviço'
    find('div#all-tab-pane').click_on order.tracking_code

    # Assert
    expect(page).to have_content "Ordem de Serviço #{order.tracking_code}"
    expect(page).to have_content 'Status: Pendente'
    expect(page).to have_content 'Distância: 300 km'

    expect(page).to have_content 'Dados do Produto'
    expect(page).to have_content 'SKU: TV32P-SAMSUNG-XPTO90'
    expect(page).to have_content 'Dimensões: 100 cm x 40 cm x 60 cm'
    expect(page).to have_content 'Peso: 3 kg'

    expect(page).to have_content 'Dados do Destinatário'
    expect(page).to have_content 'Destinatário: Denise Silva'
    expect(page).to have_content 'CPF do Destinatário: 000.000.000-00'
    expect(page).to have_content 'E-mail do Destinatário: denise@email.com'
    expect(page).to have_content 'Telefone do Destinatário: (22) 9752-3040'
    
    expect(page).to have_content 'Dados para Retirada'
    expect(page).to have_content 'Local de Retirada: Estrada do Porto, 70 - São Paulo - SP'
    expect(page).to have_content 'CEP de Retirada: 30.000-000'

    expect(page).to have_content 'Dados para Entrega'
    expect(page).to have_content 'Local de Entrega: Rua das Palmeiras, 13 - Rio de Janeiro - RJ'
    expect(page).to have_content 'CEP de Entrega: 28.200-000' 
  end

  it 'e não está logado' do
    # Arrange
    order = Order.create!(delivery_address: 'Rua das Palmeiras, 13', delivery_city: 'Rio de Janeiro', delivery_state: 'RJ', 
                          delivery_postal_code: '28200000', recipient: 'Denise Silva', recipient_cpf: '00000000000',
                          recipient_email: 'denise@email.com', recipient_phone_number: '2297523040', 
                          pick_up_address: 'Estrada do Porto, 70', pick_up_city: 'São Paulo', pick_up_state: 'SP', 
                          pick_up_postal_code: '30000000', sku: 'TV32P-SAMSUNG-XPTO90', height: 60, width: 40, length: 100, 
                          weight: 3000, distance: 300)

    # Act
    visit order_path(order.id)

    # Assert
    expect(current_path).to eq new_user_session_path
    expect(page).not_to have_content order.tracking_code
  end
end