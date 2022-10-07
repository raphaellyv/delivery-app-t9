require 'rails_helper'

describe 'Usuário edita uma modalidade de transporte' do
  it 'e precisa estar autenticado' do
    # Arrange
    so = ShippingOption.create!(name: 'Entrega Expressa', min_distance: 50 , max_distance: 600, min_weight: 1000, max_weight: 50000, 
                                delivery_fee: 5.50)

    # Act
    visit edit_shipping_option_path(so.id)

    # Assert
    expect(current_path).to eq new_user_session_path
  end

  context 'como administrador' do
    it 'a partir da lista de modalidades' do
      # Arrange
      admin = User.create!(name: 'Pessoa', email: 'pessoa@sistemadefrete.com.br', password: 'password', role: :admin)
  
      so = ShippingOption.create!(name: 'Entrega Expressa', min_distance: 50 , max_distance: 600, min_weight: 1000, max_weight: 50000, 
                                 delivery_fee: 5.50)

      # Act
      login_as admin
      visit root_path
      click_on 'Modalidades de Transporte'
      click_on 'Entrega Expressa'
      click_on 'Editar'

      # Assert
      expect(page).to have_content 'Editar Modalidade de Transporte'
      expect(page).to have_field 'Modalidade', with: 'Entrega Expressa'
      expect(page).to have_field 'Distância Mínima', with: '50'
      expect(page).to have_field 'Distância Máxima', with: '600'
      expect(page).to have_field 'Peso Mínimo', with: '1000'
      expect(page).to have_field 'Peso Máximo', with: '50000'
      expect(page).to have_field 'Taxa Fixa de Entrega', with: 5.5
    end

    it 'a partir da página de detalhes de uma modalidade' do
      # Arrange
      admin = User.create!(name: 'Pessoa', email: 'pessoa@sistemadefrete.com.br', password: 'password', role: :admin)
  
      so = ShippingOption.create!(name: 'Entrega Expressa', min_distance: 50 , max_distance: 600, min_weight: 1_000, max_weight: 50_000, 
                                  delivery_fee: 5.50, status: :enabled)

      # Act
      login_as admin
      visit root_path
      click_on 'Modalidades de Transporte'
      click_on 'Entrega Expressa'
      click_on 'Editar Modalidade'

      # Assert
      expect(page).to have_content 'Editar Modalidade de Transporte'
      expect(page).to have_field 'Modalidade', with: 'Entrega Expressa'
      expect(page).to have_field 'Distância Mínima', with: '50'
      expect(page).to have_field 'Distância Máxima', with: '600'
      expect(page).to have_field 'Peso Mínimo', with: '1000'
      expect(page).to have_field 'Peso Máximo', with: '50000'
      expect(page).to have_field 'Taxa Fixa de Entrega', with: 5.5
    end

    it 'com sucesso' do
      # Arrange
      admin = User.create!(name: 'Pessoa', email: 'pessoa@sistemadefrete.com.br', password: 'password', role: :admin)
  
      so = ShippingOption.create!(name: 'Entrega Expressa', min_distance: 50 , max_distance: 600, min_weight: 1000, max_weight: 50000, 
                                 delivery_fee: 5.50)

      # Act
      login_as admin
      visit root_path
      click_on 'Modalidades de Transporte'
      click_on 'Entrega Expressa'
      click_on 'Editar'
      fill_in 'Modalidade', with: 'Entrega Rápida'
      fill_in 'Distância Mínima', with: '5'
      fill_in 'Distância Máxima', with: '500'
      fill_in 'Peso Mínimo', with: '5000'
      fill_in 'Peso Máximo', with: '30000'
      fill_in 'Taxa Fixa de Entrega', with: 3.5
      click_on 'Atualizar Modalidade de Transporte'

      # Assert
      expect(page).to have_content 'Modalidade de Transporte atualizada com sucesso'
      expect(page).to have_content 'Intervalo de Distância: 5 km a 500 km'
      expect(page).to have_content 'Intervalo de Peso: 5 kg a 30 kg'
      expect(page).to have_content 'Taxa Fixa de Entrega: R$ 3,50'
    end

    it 'com dados incompletos' do
      # Arrange
      admin = User.create!(name: 'Pessoa', email: 'pessoa@sistemadefrete.com.br', password: 'password', role: :admin)
  
      so = ShippingOption.create!(name: 'Entrega Expressa', min_distance: 50 , max_distance: 600, min_weight: 1000, max_weight: 50000, 
                                 delivery_fee: 5.50)

      # Act
      login_as admin
      visit root_path
      click_on 'Modalidades de Transporte'
      click_on 'Entrega Expressa'
      click_on 'Editar'
      fill_in 'Modalidade', with: ''
      fill_in 'Distância Mínima', with: ''
      fill_in 'Distância Máxima', with: ''
      fill_in 'Peso Mínimo', with: ''
      fill_in 'Peso Máximo', with: ''
      fill_in 'Taxa Fixa de Entrega', with: ''
      click_on 'Atualizar Modalidade de Transporte'

      # Assert
      expect(page).to have_content 'Não foi possível atualizar a Modalidade de Transporte'
      expect(page).to have_content 'Modalidade não pode ficar em branco'
      expect(page).to have_content 'Distância Máxima não pode ficar em branco'
      expect(page).to have_content 'Distância Mínima não pode ficar em branco'
      expect(page).to have_content 'Peso Mínimo não pode ficar em branco'
      expect(page).to have_content 'Peso Máximo não pode ficar em branco'
      expect(page).to have_content 'Taxa Fixa de Entrega não pode ficar em branco'
    end
  end

  context 'como usuário regular' do
    it 'a partir da lista de modalidades' do
      # Arrange
      user = User.create!(name: 'Pessoa', email: 'pessoa@sistemadefrete.com.br', password: 'password', role: :regular)
  
      so = ShippingOption.create!(name: 'Entrega Expressa', min_distance: 50 , max_distance: 600, min_weight: 1000, max_weight: 50000, 
                                 delivery_fee: 5.50, status: :enabled)

      # Act
      login_as user
      visit root_path
      click_on 'Modalidades de Transporte'
      click_on 'Entrega Expressa'

      # Assert
      expect(page).to have_content 'Entrega Expressa'
      expect(page).not_to have_button 'Editar'
    end

    it 'a partir da url' do
      # Arrange
      user = User.create!(name: 'Pessoa', email: 'pessoa@sistemadefrete.com.br', password: 'password', role: :regular)
  
      so = ShippingOption.create!(name: 'Entrega Expressa', min_distance: 50 , max_distance: 600, min_weight: 1000, max_weight: 50000, 
                                 delivery_fee: 5.50, status: :enabled)

      # Act
      login_as user
      visit edit_shipping_option_path(so.id)

      # Assert
      expect(current_path).to eq shipping_options_path
    end
  end
end