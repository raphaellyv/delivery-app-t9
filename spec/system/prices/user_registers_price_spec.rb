require 'rails_helper'

describe 'Usuário cadastra um preço' do
  context 'como administrador' do
    it 'a partir da página de detalhes de uma modalidade de transporte' do
      # Arrange
      admin = User.create!(name: 'Pessoa', email: 'pessoa@sistemadefrete.com.br', password: 'password', role: :admin)

      so = ShippingOption.create!(name: 'Outra Entrega', min_distance: 60 , max_distance: 700, min_weight: 3_000, max_weight: 55_000, 
                                  delivery_fee: 3.50)

      # Act
      login_as admin
      visit root_path
      click_on 'Modalidades de Transporte'
      click_on 'Outra Entrega'
      click_on 'Cadastrar Preço'

      # Assert
      expect(page).to have_content 'Novo Preço'
      expect(page).to have_content 'Modalidade de Transporte: Outra Entrega'
      expect(page).to have_content 'Intervalo de Peso: 3 kg a 55 kg'
      expect(page).to have_field 'Peso Mínimo'
      expect(page).to have_field 'Peso Máximo'
      expect(page).to have_field 'Preço por km'
      expect(page).to have_button 'Criar Preço'
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
      click_on 'Cadastrar Preço'
      fill_in 'Peso Mínimo', with: 3_000
      fill_in 'Peso Máximo', with: 4_000
      fill_in 'Preço por km', with: 1.00
      click_on 'Criar Preço'

      # Assert
      expect(current_path).to eq new_shipping_option_price_path(so.id)
      expect(page).to have_content 'Preço cadastrado com sucesso'
      expect(page).to have_content '3 kg a 4 kg'
      expect(page).to have_content 'R$ 1,00'
    end

    it 'e não preenche todos os campos' do
      # Arrange
      admin = User.create!(name: 'Pessoa', email: 'pessoa@sistemadefrete.com.br', password: 'password', role: :admin)

      so = ShippingOption.create!(name: 'Outra Entrega', min_distance: 60 , max_distance: 700, min_weight: 3_000, max_weight: 55_000, 
                                  delivery_fee: 3.50)

      # Act
      login_as admin
      visit root_path
      click_on 'Modalidades de Transporte'
      click_on 'Outra Entrega'
      click_on 'Cadastrar Preço'
      fill_in 'Peso Mínimo', with: ''
      fill_in 'Peso Máximo', with: ''
      fill_in 'Preço por km', with: ''
      click_on 'Criar Preço'

      # Assert
      expect(page).to have_content 'Não foi possível cadastrar o preço'
      expect(page).to have_content 'Peso Mínimo não pode ficar em branco'
      expect(page).to have_content 'Peso Máximo não pode ficar em branco'
      expect(page).to have_content 'Preço por km não pode ficar em branco'
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
      expect(page).not_to have_link 'Cadastrar Preço'
    end

    it 'pela url' do
      # Arrange
      user = User.create!(name: 'Pessoa', email: 'pessoa@sistemadefrete.com.br', password: 'password', role: :regular)

      so = ShippingOption.create!(name: 'Outra Entrega', min_distance: 60 , max_distance: 700, min_weight: 3_000, max_weight: 55_000, 
                                  delivery_fee: 3.50)

      # Act
      login_as user
      visit new_shipping_option_price_path(so.id)

      # Assert
      expect(current_path).not_to eq new_shipping_option_price_path(so.id)
      expect(page).to have_content 'Área restrita a administradores'
    end
  end

  it 'e não está autenticado' do
    # Arrange
    so = ShippingOption.create!(name: 'Outra Entrega', min_distance: 60 , max_distance: 700, min_weight: 3_000, max_weight: 55_000, 
                                delivery_fee: 3.50)

    # Act
    visit new_shipping_option_price_path(so.id)

    # Assert
    expect(current_path).to eq new_user_session_path
  end
end