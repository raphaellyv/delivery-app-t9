require 'rails_helper'

describe 'Usuário vê lista de modalidades de transporte' do
  context 'como usuário regular' do
    it 'com sucesso' do
      # Arrange
      user = User.create!(name: 'Pessoa', email: 'pessoa@sistemadefrete.com.br', password: 'password', role: :regular)
  
      ShippingOption.create!(name: 'Entrega Expressa', min_distance: 50 , max_distance: 600, min_weight: 1000, max_weight: 50000, 
                              delivery_fee: 5.50)
      ShippingOption.create!(name: 'Entrega Básica', min_distance: 30 , max_distance: 800, min_weight: 1500, max_weight: 40000, 
                                delivery_fee: 3.00)
  
      # Act
      login_as user
      visit root_path
      click_on 'Modalidades de Transporte'
  
      # Assert
      within 'main' do
        expect(page).to have_content 'Modalidades de Transporte'
      end
      expect(page).to have_content 'Modalidade'
      expect(page).to have_content 'Intervalo de Distância'
      expect(page).to have_content 'Intervalo de Peso'
      expect(page).to have_content 'Taxa Fixa de Entrega'
      expect(page).to have_content 'Status'
      expect(page).to have_content 'Entrega Expressa'
      expect(page).to have_content 'Entrega Básica'
      expect(page).to have_content '50 km a 600 km'
      expect(page).to have_content '30 km a 800 km'
      expect(page).to have_content '1 kg a 50 kg'
      expect(page).to have_content '1,5 kg a 40 kg'
      expect(page).to have_content 'R$ 5,50'
      expect(page).to have_content 'R$ 3,00'
      expect(page).to have_content 'Inativa'
    end

    it 'e não existem modalidades de transporte cadastradas' do
      # Arrange
      user = User.create!(name: 'Pessoa', email: 'pessoa@sistemadefrete.com.br', password: 'password', role: :regular)

      # Act
      login_as user
      visit root_path
      click_on 'Modalidades de Transporte'

      # Assert
      expect(page).to have_content "Não existem modalidades de transporte cadastradas"
    end
  end

  context 'como administrador' do
    it 'com sucesso' do
      # Arrange
      user = User.create!(name: 'Pessoa', email: 'pessoa@sistemadefrete.com.br', password: 'password', role: :admin)
  
      ShippingOption.create!(name: 'Entrega Expressa', min_distance: 50 , max_distance: 600, min_weight: 1000, max_weight: 50000, 
                             delivery_fee: 5.50)
      ShippingOption.create!(name: 'Entrega Básica', min_distance: 30 , max_distance: 800, min_weight: 1500, max_weight: 40000, 
                             delivery_fee: 3.00)
  
      # Act
      login_as user
      visit root_path
      click_on 'Modalidades de Transporte'
  
      # Assert
      within 'main' do
        expect(page).to have_content 'Modalidades de Transporte'
      end
      expect(page).to have_content 'Modalidade'
      expect(page).to have_content 'Intervalo de Distância'
      expect(page).to have_content 'Intervalo de Peso'
      expect(page).to have_content 'Taxa Fixa de Entrega'
      expect(page).to have_content 'Status'
      expect(page).to have_content 'Entrega Expressa'
      expect(page).to have_content 'Entrega Básica'
      expect(page).to have_content '50 km a 600 km'
      expect(page).to have_content '30 km a 800 km'
      expect(page).to have_content '1 kg a 50 kg'
      expect(page).to have_content '1,5 kg a 40 kg'
      expect(page).to have_content 'R$ 5,50'
      expect(page).to have_content 'R$ 3,00'
      expect(page).to have_content 'Inativa'
    end

    it 'e não existem modalidades de transporte cadastradas' do
      # Arrange
      user = User.create!(name: 'Pessoa', email: 'pessoa@sistemadefrete.com.br', password: 'password', role: :admin)

      # Act
      login_as user
      visit root_path
      click_on 'Modalidades de Transporte'

      # Assert
      expect(page).to have_content "Não existem modalidades de transporte cadastradas"
    end
  end

  context 'e precisa estar autenticado' do
    it 'a partir da tela inicial' do
      # Arrange

      # Act
      visit root_path

      # Assert
      expect(page).not_to have_link 'Modalidades de Transporte'
    end

    it 'pela url' do
      # Arrange

      # Act
      visit shipping_options_path

      # Assert
      expect(current_path).to eq new_user_session_path
    end
  end
end