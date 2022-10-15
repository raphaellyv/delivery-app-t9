require 'rails_helper'

describe 'Usuário cadastra um prazo' do
  context 'como administrador' do
    it 'a partir da página de detalhes de uma modalidade de transporte' do
      # Arrange
      admin = User.create!(name: 'Pessoa', email: 'pessoa@sistemadefrete.com.br', password: 'password', role: :admin)

      so = ShippingOption.create!(name: 'Outra Entrega', min_distance: 60 , max_distance: 700, min_weight: 3_000, max_weight: 55_000, 
                                  delivery_fee: 3.50)

      Deadline.create!(min_distance: 101, max_distance: 500, deadline: 48, shipping_option: so)

      # Act
      login_as admin
      visit root_path
      click_on 'Modalidades de Transporte'
      click_on 'Outra Entrega'
      click_on 'Cadastrar Prazo'

      # Assert
      expect(page).to have_content 'Novo Prazo'
      expect(page).to have_content 'Modalidade de Transporte: Outra Entrega'
      expect(page).to have_content 'Intervalo de Distância: 60 km a 700 km'
      expect(page).to have_content '101 km a 500 km'
      expect(page).to have_content '48 h'
      expect(page).to have_field 'Distância Mínima'
      expect(page).to have_field 'Distância Máxima'
      expect(page).to have_field 'Prazo de Entrega'
      expect(page).to have_button 'Criar Prazo'
    end

    it 'com sucesso' do
      # Arrange
      admin = User.create!(name: 'Pessoa', email: 'pessoa@sistemadefrete.com.br', password: 'password', role: :admin)

      so = ShippingOption.create!(name: 'Outra Entrega', min_distance: 60 , max_distance: 700, min_weight: 3_000, max_weight: 55_000, 
                                  delivery_fee: 3.50)

      # Act
      login_as admin
      visit root_path
      click_on 'Modalidades de Transporte'
      click_on 'Outra Entrega'
      click_on 'Cadastrar Prazo'
      fill_in 'Distância Mínima', with: 101
      fill_in 'Distância Máxima', with: 300
      fill_in 'Prazo de Entrega', with: 48
      click_on 'Criar Prazo'

      # Assert
      expect(current_path).to eq new_shipping_option_deadline_path(so.id)
      expect(page).to have_content 'Prazo cadastrado com sucesso'
      expect(page).to have_content '101 km a 300 km'
      expect(page).to have_content '48 h'
    end

    it 'com campos incompletos' do
      # Arrange
      admin = User.create!(name: 'Pessoa', email: 'pessoa@sistemadefrete.com.br', password: 'password', role: :admin)

      so = ShippingOption.create!(name: 'Outra Entrega', min_distance: 60 , max_distance: 700, min_weight: 3_000, max_weight: 55_000, 
                                  delivery_fee: 3.50)

      # Act
      login_as admin
      visit root_path
      click_on 'Modalidades de Transporte'
      click_on 'Outra Entrega'
      click_on 'Cadastrar Prazo'
      fill_in 'Distância Mínima', with: ''
      fill_in 'Distância Máxima', with: ''
      fill_in 'Prazo de Entrega', with: ''
      click_on 'Criar Prazo'

      # Assert
      expect(page).to have_content 'Não foi possível cadastrar o Prazo'
      expect(page).to have_content 'Distância Mínima não pode ficar em branco'
      expect(page).to have_content 'Distância Máxima não pode ficar em branco'
      expect(page).to have_content 'Prazo de Entrega não pode ficar em branco'
    end
  end

  context 'como usuário regular' do
    it 'a partir da página de detalhes de uma modalidade de transporte' do
      # Arrange
      user = User.create!(name: 'Pessoa', email: 'pessoa@sistemadefrete.com.br', password: 'password', role: :regular)

      so = ShippingOption.create!(name: 'Outra Entrega', min_distance: 60 , max_distance: 700, min_weight: 3_000, max_weight: 55_000, 
                                  delivery_fee: 3.50)

      # Act
      login_as user
      visit root_path
      click_on 'Modalidades de Transporte'
      click_on 'Outra Entrega'

      # Assert
      expect(page).not_to have_link 'Cadastrar Prazo'
    end

    it 'pela url' do
      # Arrange
      user = User.create!(name: 'Pessoa', email: 'pessoa@sistemadefrete.com.br', password: 'password', role: :regular)

      so = ShippingOption.create!(name: 'Outra Entrega', min_distance: 60 , max_distance: 700, min_weight: 3_000, max_weight: 55_000, 
                                  delivery_fee: 3.50)

      # Act
      login_as user
      visit new_shipping_option_deadline_path(so.id)

      # Assert
      expect(current_path).to eq root_path
    end
  end

  it 'e não está autenticado' do
    # Arrange
    so = ShippingOption.create!(name: 'Outra Entrega', min_distance: 60 , max_distance: 700, min_weight: 3_000, max_weight: 55_000, 
                                delivery_fee: 3.50)

    # Act
    visit new_shipping_option_deadline_path(so.id)

    # Assert
    expect(current_path).to eq new_user_session_path
  end
end