require 'rails_helper'

describe 'Usuário cria ordem de serviço' do
  it 'e deve estar autenticado' do
    # Arrange
    
    # Act
    visit new_order_path

    # Assert
    expect(current_path).to eq new_user_session_path
  end

  it 'e não deve ser um usuário regular' do
    # Arrange
    user = User.create!(name: 'Pessoa', email: 'pessoa@sistemadefrete.com.br', password: 'password', role: :regular)

    # Act
    login_as user
    visit new_order_path

    # Assert
    expect(current_path).to eq root_path
    expect(page).to have_content 'Área restrita para administradores'
  end

  context 'como administrador' do
    it 'a partir da lista de ordens de serviço' do
      # Arrange
      admin = User.create!(name: 'Pessoa', email: 'pessoa@sistemadefrete.com.br', password: 'password', role: :admin)
  
      # Act
      login_as admin
      visit root_path
      click_on 'Ordens de Serviço'
      click_on 'Cadastrar Ordem de Serviço'

      # Assert
      expect(page).to have_content 'Nova Ordem de Serviço'

      expect(page).to have_content 'Dados do Produto'
      expect(page).to have_field 'SKU'
      expect(page).to have_field 'Comprimento'
      expect(page).to have_field 'Largura'
      expect(page).to have_field 'Altura'
      expect(page).to have_field 'Peso'
      
      expect(page).to have_content 'Dados do Destinatário'
      expect(page).to have_field 'Destinatário'
      expect(page).to have_field 'CPF do Destinatário'
      expect(page).to have_field 'E-mail do Destinatário'
      expect(page).to have_field 'Telefone do Destinatário' 
      
      expect(page).to have_content 'Dados para Retirada'
      expect(page).to have_field 'Endereço de Retirada'
      expect(page).to have_field 'Cidade de Retirada'
      expect(page).to have_field 'Estado de Retirada'
      expect(page).to have_field 'CEP de Retirada'
      
      expect(page).to have_content 'Dados para Entrega'
      expect(page).to have_field 'Endereço de Entrega'
      expect(page).to have_field 'Cidade de Entrega'
      expect(page).to have_field 'Estado de Entrega'
      expect(page).to have_field 'CEP de Entrega'
  
      expect(page).to have_field 'Distância'
      expect(page).to have_button 'Criar Ordem de Serviço'
    end

    it 'com sucesso' do
      # Arrange
      admin = User.create!(name: 'Pessoa', email: 'pessoa@sistemadefrete.com.br', password: 'password', role: :admin)
  
      # Act
      login_as admin
      visit root_path
      click_on 'Ordens de Serviço'
      click_on 'Cadastrar Ordem de Serviço'
  
      fill_in 'SKU', with: 'TV32P-SAMSUNG-XPTO90'
      fill_in 'Comprimento', with: '100'
      fill_in 'Largura', with: '40'
      fill_in 'Altura', with: '60'
      fill_in 'Peso', with: '3000'
  
      fill_in 'Destinatário', with: 'Denise Silva'
      fill_in 'CPF do Destinatário', with: '00000000000'
      fill_in 'E-mail do Destinatário', with: 'denise@email.com'
      fill_in 'Telefone do Destinatário', with: '2297523040'
  
      fill_in 'Endereço de Retirada', with: 'Estrada do Porto, 70'
      fill_in 'Cidade de Retirada', with: 'São Paulo'
      fill_in 'Estado de Retirada', with: 'SP'
      fill_in 'CEP de Retirada', with: '30000000'
  
      fill_in 'Endereço de Entrega', with: 'Rua das Palmeiras, 13'
      fill_in 'Cidade de Entrega', with: 'Rio de Janeiro'
      fill_in 'Estado de Entrega', with: 'RJ'
      fill_in 'CEP de Entrega', with: '28200000' 
  
      fill_in 'Distância', with: 300
  
      click_on 'Criar Ordem de Serviço'
  
      # Assert
      expect(page).to have_content 'Ordem de Serviço cadastrada com sucesso'
      expect(page).to have_content "Ordem de Serviço #{Order.find(1).tracking_code}"
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

    it 'com dados incompletos' do
      # Arrange
      admin = User.create!(name: 'Pessoa', email: 'pessoa@sistemadefrete.com.br', password: 'password', role: :admin)
  
      # Act
      login_as admin
      visit root_path
      click_on 'Ordens de Serviço'
      click_on 'Cadastrar Ordem de Serviço'
  
      fill_in 'SKU', with: ''
      fill_in 'Comprimento', with: ''
      fill_in 'Largura', with: ''
      fill_in 'Altura', with: ''
      fill_in 'Peso', with: ''
  
      fill_in 'Destinatário', with: ''
      fill_in 'CPF do Destinatário', with: ''
      fill_in 'E-mail do Destinatário', with: ''
      fill_in 'Telefone do Destinatário', with: ''
  
      fill_in 'Endereço de Retirada', with: ''
      fill_in 'Cidade de Retirada', with: ''
      fill_in 'Estado de Retirada', with: ''
      fill_in 'CEP de Retirada', with: ''
  
      fill_in 'Endereço de Entrega', with: ''
      fill_in 'Cidade de Entrega', with: ''
      fill_in 'Estado de Entrega', with: ''
      fill_in 'CEP de Entrega', with: '' 
  
      fill_in 'Distância', with: ''
  
      click_on 'Criar Ordem de Serviço'
  
      # Assert
      expect(page).to have_content 'Não foi possível cadastrar a Ordem de Serviço'
      expect(page).to have_content 'SKU não pode ficar em branco'
      expect(page).to have_content 'Comprimento não pode ficar em branco'
      expect(page).to have_content 'Largura não pode ficar em branco'
      expect(page).to have_content 'Altura não pode ficar em branco'
      expect(page).to have_content 'Peso não pode ficar em branco'

      expect(page).to have_content 'Destinatário não pode ficar em branco'
      expect(page).to have_content 'CPF do Destinatário não pode ficar em branco'
      expect(page).to have_content 'E-mail do Destinatário não pode ficar em branco'
      expect(page).to have_content 'Telefone do Destinatário não pode ficar em branco'

      expect(page).to have_content 'Endereço de Retirada não pode ficar em branco'
      expect(page).to have_content 'Cidade de Retirada não pode ficar em branco'
      expect(page).to have_content 'Estado de Retirada não pode ficar em branco'
      expect(page).to have_content 'CEP de Retirada não pode ficar em branco'

      expect(page).to have_content 'Endereço de Entrega não pode ficar em branco'
      expect(page).to have_content 'Cidade de Entrega não pode ficar em branco'
      expect(page).to have_content 'Estado de Entrega não pode ficar em branco'
      expect(page).to have_content 'CEP de Entrega não pode ficar em branco'
    end
  end
end