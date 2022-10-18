require 'rails_helper'

describe 'Usuário vê ordens finalizadas sem atraso' do
  context 'como usuário regular' do
    it 'com sucesso' do
      # Arrange
      user = User.create!(name: 'Pessoa', email: 'pessoa@sistemadefrete.com.br', password: 'password', role: :regular)
  
      first_order = Order.create!(delivery_address: 'Rua das Palmeiras, 13', delivery_city: 'Rio de Janeiro', delivery_state: 'RJ', 
                                  delivery_postal_code: '28200000', recipient: 'Denise Silva', recipient_cpf: '00000000000',
                                  recipient_email: 'denise@email.com', recipient_phone_number: '00000000000', 
                                  pick_up_address: 'Estrada do Porto, 70', pick_up_city: 'São Paulo', pick_up_state: 'SP', 
                                  pick_up_postal_code: '30000000', sku: 'TV32P-SAMSUNG-XPTO90', height: 60, width: 40, length: 100, 
                                  weight: 300, distance: 1_000, status: :delivered_late)
    
      # Act
      login_as user
      visit root_path
      click_on 'Ordens de Serviço'
      click_on 'Finalizadas com Atraso'
      
      # Assert
      expect(page).to have_content 'Status'
      expect(page).to have_content 'Código de Rastreio'      
      expect(page).to have_link first_order.tracking_code
      expect(page).to have_content 'Distância'
      expect(page).to have_content '1 000 km'
      expect(page).to have_content 'Origem'
      expect(page).to have_content 'São Paulo - SP'
      expect(page).to have_content 'Destino'
      expect(page).to have_content 'Rio de Janeiro - RJ'
      expect(page).not_to have_link 'Cadastrar Ordem de Serviço'
    end

    it 'e não existem ordens finalizadas com atraso' do
      # Arrange
      user = User.create!(name: 'Pessoa', email: 'pessoa@sistemadefrete.com.br', password: 'password', role: :regular)
                                  
      first_order = Order.create!(delivery_address: 'Rua das Oliveiras, 15', delivery_city: 'São Gonçalo', delivery_state: 'RJ', 
                                  delivery_postal_code: '28200000', recipient: 'Marta Silva', recipient_cpf: '00000000000',
                                  recipient_email: 'martae@email.com', recipient_phone_number: '00000000000', 
                                  pick_up_address: 'Estrada do Porto, 70', pick_up_city: 'Santo André', pick_up_state: 'SP', 
                                  pick_up_postal_code: '30000000', sku: 'TV32P-SAMSUNG-XPTO90', height: 60, width: 40, length: 100, 
                                  weight: 300, distance: 1_200, status: :pending)

      second_order = Order.create!(delivery_address: 'Rua das Oliveiras, 15', delivery_city: 'São Gonçalo', delivery_state: 'RJ', 
                                   delivery_postal_code: '28200000', recipient: 'Marta Silva', recipient_cpf: '00000000000',
                                   recipient_email: 'martae@email.com', recipient_phone_number: '00000000000', 
                                   pick_up_address: 'Estrada do Porto, 70', pick_up_city: 'Santo André', pick_up_state: 'SP', 
                                   pick_up_postal_code: '30000000', sku: 'TV32P-SAMSUNG-XPTO90', height: 60, width: 40, length: 100, 
                                   weight: 300, distance: 1_200, status: :en_route)

      third_order = Order.create!(delivery_address: 'Rua das Oliveiras, 15', delivery_city: 'São Gonçalo', delivery_state: 'RJ', 
                                  delivery_postal_code: '28200000', recipient: 'Marta Silva', recipient_cpf: '00000000000',
                                  recipient_email: 'martae@email.com', recipient_phone_number: '00000000000', 
                                  pick_up_address: 'Estrada do Porto, 70', pick_up_city: 'Santo André', pick_up_state: 'SP', 
                                  pick_up_postal_code: '30000000', sku: 'TV32P-SAMSUNG-XPTO90', height: 60, width: 40, length: 100, 
                                  weight: 300, distance: 1_200, status: :delivered_on_time) 
    
      # Act
      login_as user
      visit root_path
      click_on 'Ordens de Serviço'
      click_on 'Finalizadas com Atraso'
      
      # Assert
      expect(page).to have_content 'Não existem ordens de serviço finalizadas com atraso'
      within 'div#delivered_late-tab-pane' do
        expect(page).not_to have_content first_order.tracking_code
        expect(page).not_to have_content second_order.tracking_code
        expect(page).not_to have_content third_order.tracking_code
      end
    end
  end

  context 'como administrador' do
    it 'com sucesso' do
      # Arrange
      admin = User.create!(name: 'Pessoa', email: 'pessoa@sistemadefrete.com.br', password: 'password', role: :admin)
  
      first_order = Order.create!(delivery_address: 'Rua das Palmeiras, 13', delivery_city: 'Rio de Janeiro', delivery_state: 'RJ', 
                                  delivery_postal_code: '28200000', recipient: 'Denise Silva', recipient_cpf: '00000000000',
                                  recipient_email: 'denise@email.com', recipient_phone_number: '00000000000', 
                                  pick_up_address: 'Estrada do Porto, 70', pick_up_city: 'São Paulo', pick_up_state: 'SP', 
                                  pick_up_postal_code: '30000000', sku: 'TV32P-SAMSUNG-XPTO90', height: 60, width: 40, length: 100, 
                                  weight: 300, distance: 1_000, status: :delivered_late)
    
      # Act
      login_as admin
      visit root_path
      click_on 'Ordens de Serviço'
      click_on 'Finalizadas com Atraso'
      
      # Assert
      expect(page).to have_content 'Status'
      expect(page).to have_content 'Código de Rastreio'      
      expect(page).to have_link first_order.tracking_code
      expect(page).to have_content 'Distância'
      expect(page).to have_content '1 000 km'
      expect(page).to have_content 'Origem'
      expect(page).to have_content 'São Paulo - SP'
      expect(page).to have_content 'Destino'
      expect(page).to have_content 'Rio de Janeiro - RJ'
      expect(page).to have_link 'Cadastrar Ordem de Serviço'
    end
  end

  it 'e não existem ordens finalizadas com atraso' do
    # Arrange
    admin = User.create!(name: 'Pessoa', email: 'pessoa@sistemadefrete.com.br', password: 'password', role: :admin)
                                
    first_order = Order.create!(delivery_address: 'Rua das Oliveiras, 15', delivery_city: 'São Gonçalo', delivery_state: 'RJ', 
                                delivery_postal_code: '28200000', recipient: 'Marta Silva', recipient_cpf: '00000000000',
                                recipient_email: 'martae@email.com', recipient_phone_number: '00000000000', 
                                pick_up_address: 'Estrada do Porto, 70', pick_up_city: 'Santo André', pick_up_state: 'SP', 
                                pick_up_postal_code: '30000000', sku: 'TV32P-SAMSUNG-XPTO90', height: 60, width: 40, length: 100, 
                                weight: 300, distance: 1_200, status: :pending)

    second_order = Order.create!(delivery_address: 'Rua das Oliveiras, 15', delivery_city: 'São Gonçalo', delivery_state: 'RJ', 
                                 delivery_postal_code: '28200000', recipient: 'Marta Silva', recipient_cpf: '00000000000',
                                 recipient_email: 'martae@email.com', recipient_phone_number: '00000000000', 
                                 pick_up_address: 'Estrada do Porto, 70', pick_up_city: 'Santo André', pick_up_state: 'SP', 
                                 pick_up_postal_code: '30000000', sku: 'TV32P-SAMSUNG-XPTO90', height: 60, width: 40, length: 100, 
                                 weight: 300, distance: 1_200, status: :en_route)

    third_order = Order.create!(delivery_address: 'Rua das Oliveiras, 15', delivery_city: 'São Gonçalo', delivery_state: 'RJ', 
                                delivery_postal_code: '28200000', recipient: 'Marta Silva', recipient_cpf: '00000000000',
                                recipient_email: 'martae@email.com', recipient_phone_number: '00000000000', 
                                pick_up_address: 'Estrada do Porto, 70', pick_up_city: 'Santo André', pick_up_state: 'SP', 
                                pick_up_postal_code: '30000000', sku: 'TV32P-SAMSUNG-XPTO90', height: 60, width: 40, length: 100, 
                                weight: 300, distance: 1_200, status: :delivered_on_time) 
  
    # Act
    login_as admin
    visit root_path
    click_on 'Ordens de Serviço'
    click_on 'Finalizadas com Atraso'
    
    # Assert
    expect(page).to have_content 'Não existem ordens de serviço finalizadas com atraso'
    within 'div#delivered_late-tab-pane' do
      expect(page).not_to have_content first_order.tracking_code
      expect(page).not_to have_content second_order.tracking_code
      expect(page).not_to have_content third_order.tracking_code
    end
  end
end