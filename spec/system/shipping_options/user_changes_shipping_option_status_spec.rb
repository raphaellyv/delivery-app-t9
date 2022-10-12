require 'rails_helper'

describe 'Usuário altera o status da modalidade de transporte' do
  context 'como usuário regular' do
    it 'pela lista de modalidades' do
      # Arrange
      user = User.create!(name: 'Pessoa', email: 'pessoa@sistemadefrete.com.br', password: 'password', role: :regular)
  
      ShippingOption.create!(name: 'Entrega Expressa', min_distance: 50 , max_distance: 600, min_weight: 1000, max_weight: 50000, 
                             delivery_fee: 5.50, status: :enabled)
  
      # Act
      login_as user
      visit root_path
      click_on 'Modalidades de Transporte'
      click_on 'Entrega Expressa'
  
      # Assert
      expect(page).not_to have_button 'Ativar'
      expect(page).not_to have_button 'Desativar'
    end

    it 'pela url' do
      # Arrange
      user = User.create!(name: 'Pessoa', email: 'pessoa@sistemadefrete.com.br', password: 'password', role: :regular)
  
      so = ShippingOption.create!(name: 'Entrega Expressa', min_distance: 50 , max_distance: 600, min_weight: 1000, max_weight: 50000, 
                             delivery_fee: 5.50, status: :disabled)
  
      # Act
      login_as user
      visit shipping_option_path(so.id)
  
      # Assert
      expect(page).not_to have_button 'Ativar'
      expect(page).not_to have_button 'Desativar'
    end
  end

  context 'como administrador' do
    it 'a partir da lista de modalidades de transporte' do
      # Arrange
      admin = User.create!(name: 'Pessoa', email: 'pessoa@sistemadefrete.com.br', password: 'password', role: :admin)

      ShippingOption.create!(name: 'Entrega Expressa', min_distance: 50 , max_distance: 600, min_weight: 1000, max_weight: 50000, 
                             delivery_fee: 5.50)

      # Act
      login_as admin
      visit root_path
      click_on 'Modalidades de Transporte'
      click_on 'Entrega Expressa'

      # Assert
      expect(page).to have_button 'Desativar'
      expect(page).not_to have_button 'Ativar'
    end

    it 'para ativa' do
      # Arrange
      admin = User.create!(name: 'Pessoa', email: 'pessoa@sistemadefrete.com.br', password: 'password', role: :admin)

      so = ShippingOption.create!(name: 'Entrega Expressa', min_distance: 50 , max_distance: 600, min_weight: 1000, max_weight: 50000, 
                             delivery_fee: 5.50, status: :disabled)

      # Act
      login_as admin
      visit root_path
      click_on 'Modalidades de Transporte'
      click_on 'Entrega Expressa'
      click_on 'Ativar'

      # Assert
      expect(page).to have_content 'Modalidade de Transporte ativada com sucesso'
      expect(page).to have_button 'Desativar'
    end

    it 'para inativa' do
      # Arrange
      admin = User.create!(name: 'Pessoa', email: 'pessoa@sistemadefrete.com.br', password: 'password', role: :admin)

      ShippingOption.create!(name: 'Entrega Expressa', min_distance: 50 , max_distance: 600, min_weight: 1000, max_weight: 50000, 
                                  delivery_fee: 5.50, status: :enabled)

      # Act
      login_as admin
      visit root_path
      click_on 'Modalidades de Transporte'
      click_on 'Entrega Expressa'
      click_on 'Desativar'

      # Assert
      expect(page).to have_content 'Modalidade de Transporte desativada com sucesso'
      expect(page).to have_button 'Ativar'
    end
  end
end