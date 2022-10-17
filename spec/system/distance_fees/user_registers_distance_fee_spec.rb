require 'rails_helper'

describe 'Usuário cadastra uma taxa por distância' do
  context 'como administrador' do
    it 'a partir da página de detalhes de uma modalidade de transporte' do
      # Arrange
      admin = User.create!(name: 'Pessoa', email: 'pessoa@sistemadefrete.com.br', password: 'password', role: :admin)

      so = ShippingOption.create!(name: 'Outra Entrega', min_distance: 60 , max_distance: 700, min_weight: 3_000, max_weight: 55_000, 
                                  delivery_fee: 3.50)

      DistanceFee.create!(min_distance: 60, max_distance: 200, fee: 7.00, shipping_option: so)

      # Act
      login_as admin
      visit root_path
      click_on 'Modalidades de Transporte'
      click_on 'Outra Entrega'
      click_on 'Cadastrar Taxa por Distância'

      # Assert
      expect(page).to have_content 'Nova Taxa por Distância'
      expect(page).to have_content 'Modalidade de Transporte'
      expect(page).to have_content 'Outra Entrega'
      expect(page).to have_content 'Intervalo de Distância'
      expect(page).to have_content '60 km a 200 km'
      expect(page).to have_content 'R$ 7,00'
      expect(page).to have_content 'Modalidade de Transporte: Outra Entrega'
      expect(page).to have_content 'Intervalo de Distância: 60 km a 700 km'
      expect(page).to have_field 'Distância Mínima'
      expect(page).to have_field 'Distância Máxima'
      expect(page).to have_field 'Taxa'
      expect(page).to have_button 'Criar Taxa por Distância'
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
      click_on 'Cadastrar Taxa por Distância'
      fill_in 'Distância Mínima', with: 60
      fill_in 'Distância Máxima', with: 80
      fill_in 'Taxa', with: 1.00
      click_on 'Criar Taxa por Distância'

      # Assert
      expect(current_path).to eq new_shipping_option_distance_fee_path(so.id)
      expect(page).to have_content 'Taxa por Distância cadastrada com sucesso'
      expect(page).to have_content '60 km a 80 km'
      expect(page).to have_content 'R$ 1,00'
    end

    it 'com dados incompletos' do
      # Arrange
      admin = User.create!(name: 'Pessoa', email: 'pessoa@sistemadefrete.com.br', password: 'password', role: :admin)

      so = ShippingOption.create!(name: 'Outra Entrega', min_distance: 60 , max_distance: 700, min_weight: 3_000, max_weight: 55_000, 
                                  delivery_fee: 3.50)

      # Act
      login_as admin
      visit root_path
      click_on 'Modalidades de Transporte'
      click_on 'Outra Entrega'
      click_on 'Cadastrar Taxa por Distância'
      fill_in 'Distância Mínima', with: ''
      fill_in 'Distância Máxima', with: ''
      fill_in 'Taxa', with: ''
      click_on 'Criar Taxa por Distância'

      # Assert
      expect(page).to have_content 'Não foi possível cadastrar a Taxa por Distância'
      expect(page).to have_content 'Distância Mínima não pode ficar em branco'
      expect(page).to have_content 'Distância Máxima não pode ficar em branco'
      expect(page).to have_content 'Taxa não pode ficar em branco'
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
      expect(page).not_to have_link 'Cadastrar Taxa por Distância'
    end

    it 'pela url' do
      # Arrange
      user = User.create!(name: 'Pessoa', email: 'pessoa@sistemadefrete.com.br', password: 'password', role: :regular)

      so = ShippingOption.create!(name: 'Outra Entrega', min_distance: 60 , max_distance: 700, min_weight: 3_000, max_weight: 55_000, 
                                  delivery_fee: 3.50)

      # Act
      login_as user
      visit new_shipping_option_distance_fee_path(so.id)

      # Assert
      expect(current_path).to eq root_path
    end
  end

  it 'e não está autenticado' do
    # Arrange
   so = ShippingOption.create!(name: 'Outra Entrega', min_distance: 60 , max_distance: 700, min_weight: 3_000, max_weight: 55_000, 
                                delivery_fee: 3.50)

    # Act
    visit new_shipping_option_distance_fee_path(so.id)

    # Assert
    expect(current_path).to eq new_user_session_path
  end
end