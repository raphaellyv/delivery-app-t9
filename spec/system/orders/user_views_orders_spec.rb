require 'rails_helper'

describe 'Usuário vê ordens de serviço' do
  it 'a partir da tela inicial' do
    # Arrange
    
    # Act
    visit root_path

    # Assert
    expect(page).not_to have_link 'Ordens de Serviço'
  end

  it 'se estiver autenticado' do
    # Arrange

    # Act
    visit orders_path

    # Assert
    expect(page).not_to have_content 'Ordens de Serviço'
    expect(current_path).to eq new_user_session_path
  end

  context 'como administrador' do
    it 'com sucesso' do
      # Arrange
      user = User.create!(name: 'Pessoa', email: 'pessoa@sistemadefrete.com.br', password: 'password', role: :admin)
  
      first_order = Order.create!(delivery_address: 'Rua das Palmeiras, 13', delivery_city: 'Rio de Janeiro', delivery_state: 'RJ', 
                                  delivery_postal_code: '28200000', recipient: 'Denise Silva', recipient_cpf: '00000000000',
                                  recipient_email: 'denise@email.com', recipient_phone_number: '00000000000', 
                                  pick_up_address: 'Estrada do Porto, 70', pick_up_city: 'São Paulo', pick_up_state: 'SP', 
                                  pick_up_postal_code: '30000000', sku: 'TV32P-SAMSUNG-XPTO90', height: 60, width: 40, length: 100, 
                                  weight: 300, distance: 1_000)
                                  
      second_order = Order.create!(delivery_address: 'Rua das Oliveiras, 15', delivery_city: 'São Gonçalo', delivery_state: 'RJ', 
                                  delivery_postal_code: '28200000', recipient: 'Marta Silva', recipient_cpf: '00000000000',
                                  recipient_email: 'martae@email.com', recipient_phone_number: '00000000000', 
                                  pick_up_address: 'Estrada do Porto, 70', pick_up_city: 'Santo André', pick_up_state: 'SP', 
                                  pick_up_postal_code: '30000000', sku: 'TV32P-SAMSUNG-XPTO90', height: 60, width: 40, length: 100, 
                                  weight: 300, distance: 1_200)
  
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
      expect(page).to have_content first_order.tracking_code
      expect(page).to have_content second_order.tracking_code
      expect(page).to have_content 'Distância'
      expect(page).to have_content '1 000 km'
      expect(page).to have_content '1 200 km'
      expect(page).to have_content 'Origem'
      expect(page).to have_content 'São Paulo - SP'
      expect(page).to have_content 'Santo André - SP'
      expect(page).to have_content 'Destino'
      expect(page).to have_content 'Rio de Janeiro - RJ'
      expect(page).to have_content 'São Gonçalo - RJ'
    end

    it 'e não existem ordens de serviço cadastradas' do
      # Arrange
      user = User.create!(name: 'Pessoa', email: 'pessoa@sistemadefrete.com.br', password: 'password', role: :admin)

      # Act
      login_as user
      visit root_path
      click_on 'Ordens de Serviço'
     
      # Assert
      expect(page).to have_content 'Não existem ordens de serviço cadastradas'
    end
  end

  context 'como usuário regular' do
    it 'com sucesso' do
      # Arrange
      user = User.create!(name: 'Pessoa', email: 'pessoa@sistemadefrete.com.br', password: 'password', role: :regular)
  
      first_order = Order.create!(delivery_address: 'Rua das Palmeiras, 13', delivery_city: 'Rio de Janeiro', delivery_state: 'RJ', 
                                  delivery_postal_code: '28200000', recipient: 'Denise Silva', recipient_cpf: '00000000000',
                                  recipient_email: 'denise@email.com', recipient_phone_number: '00000000000', 
                                  pick_up_address: 'Estrada do Porto, 70', pick_up_city: 'São Paulo', pick_up_state: 'SP', 
                                  pick_up_postal_code: '30000000', sku: 'TV32P-SAMSUNG-XPTO90', height: 60, width: 40, length: 100, 
                                  weight: 300, distance: 1_000)
                                  
      second_order = Order.create!(delivery_address: 'Rua das Oliveiras, 15', delivery_city: 'São Gonçalo', delivery_state: 'RJ', 
                                  delivery_postal_code: '28200000', recipient: 'Marta Silva', recipient_cpf: '00000000000',
                                  recipient_email: 'martae@email.com', recipient_phone_number: '00000000000', 
                                  pick_up_address: 'Estrada do Porto, 70', pick_up_city: 'Santo André', pick_up_state: 'SP', 
                                  pick_up_postal_code: '30000000', sku: 'TV32P-SAMSUNG-XPTO90', height: 60, width: 40, length: 100, 
                                  weight: 300, distance: 1_200)
  
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
      expect(page).not_to have_link 'Cadastrar Ordem de Serviço'
      expect(page).to have_content 'Status'
      expect(page).to have_content 'Pendente'
      expect(page).to have_content 'Código de Rastreio'
      expect(page).to have_content first_order.tracking_code
      expect(page).to have_content second_order.tracking_code
      expect(page).to have_content 'Distância'
      expect(page).to have_content '1 000 km'
      expect(page).to have_content '1 200 km'
      expect(page).to have_content 'Origem'
      expect(page).to have_content 'São Paulo - SP'
      expect(page).to have_content 'Santo André - SP'
      expect(page).to have_content 'Destino'
      expect(page).to have_content 'Rio de Janeiro - RJ'
      expect(page).to have_content 'São Gonçalo - RJ'
    end

    it 'e não existem ordens de serviço cadastradas' do
      # Arrange
      user = User.create!(name: 'Pessoa', email: 'pessoa@sistemadefrete.com.br', password: 'password', role: :regular)

      # Act
      login_as user
      visit root_path
      click_on 'Ordens de Serviço'
     
      # Assert
      expect(page).to have_content 'Não existem ordens de serviço cadastradas'
    end
  end
end