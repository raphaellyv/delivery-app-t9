require 'rails_helper'

describe 'Usuário edita preço' do
  context 'como administrador' do
    it 'a partir da lista de preços' do
      # Arrange
      admin = User.create!(name: 'Pessoa', email: 'pessoa@sistemadefrete.com.br', password: 'password', role: :admin)

      so = ShippingOption.create!(name: 'Outra Entrega', min_distance: 60 , max_distance: 700, min_weight: 3_000, max_weight: 55_000, 
                                  delivery_fee: 3.50)

      Price.create!(min_weight: 3_000, max_weight: 10_000, price_per_km: 6.00, shipping_option: so)

      # Act
      login_as admin
      visit root_path
      click_on 'Preços'
      click_on 'Editar'

      # Assert
      expect(page).to have_content 'Editar Preço'
      expect(page).to have_content 'Modalidade de Transporte: Outra Entrega'
      expect(page).to have_content 'Intervalo de Peso: 3 kg a 55 kg'
      expect(page).to have_content '3 kg a 10 kg'
      expect(page).to have_content 'R$ 6,00'
      expect(page).to have_field 'Peso Mínimo', with: '3000'
      expect(page).to have_field 'Peso Máximo', with: '10000'
      expect(page).to have_field 'Preço', with: 6.0
      expect(page).to have_button 'Atualizar Preço'
    end

    it 'com sucesso' do
      # Arrange
      admin = User.create!(name: 'Pessoa', email: 'pessoa@sistemadefrete.com.br', password: 'password', role: :admin)

      so = ShippingOption.create!(name: 'Outra Entrega', min_distance: 60 , max_distance: 700, min_weight: 3_000, max_weight: 55_000, 
                                  delivery_fee: 3.50)

      Price.create!(min_weight: 3_000, max_weight: 10_000, price_per_km: 6.00, shipping_option: so)

      # Act
      login_as admin
      visit root_path
      click_on 'Preços'
      click_on 'Editar'
      fill_in 'Peso Mínimo', with: 3_500
      fill_in 'Peso Máximo', with: 7_500
      fill_in 'Preço por km', with: 5.00
      click_on 'Atualizar Preço'

      # Assert
      expect(page).to have_content 'Preço atualizado com sucesso'
      expect(page).to have_content 'Modalidade Outra Entrega'
      expect(page).to have_content 'Intervalo de Peso: 3 kg a 55 kg'
      expect(page).to have_content '3,5 kg a 7,5 kg'
      expect(page).to have_content 'R$ 5,00'
    end

    it 'com dados incompletos' do
      # Arrange
      admin = User.create!(name: 'Pessoa', email: 'pessoa@sistemadefrete.com.br', password: 'password', role: :admin)

      so = ShippingOption.create!(name: 'Outra Entrega', min_distance: 60 , max_distance: 700, min_weight: 3_000, max_weight: 55_000, 
                                  delivery_fee: 3.50)

      Price.create!(min_weight: 3_000, max_weight: 10_000, price_per_km: 6.00, shipping_option: so)

      # Act
      login_as admin
      visit root_path
      click_on 'Preços'
      click_on 'Editar'
      fill_in 'Peso Mínimo', with: ''
      fill_in 'Peso Máximo', with: ''
      fill_in 'Preço por km', with: ''
      click_on 'Atualizar Preço'

      # Assert
      expect(page).to have_content 'Não foi possível atualizar o Preço'
      expect(page).to have_content 'Peso Mínimo não pode ficar em branco'
      expect(page).to have_content 'Peso Máximo não pode ficar em branco'
      expect(page).to have_content 'Preço por km não pode ficar em branco'
    end
  end

  context 'como usuário regular' do
    it 'a partir da lista de preços' do
      # Arrange
      user = User.create!(name: 'Pessoa', email: 'pessoa@sistemadefrete.com.br', password: 'password', role: :regular)

      so = ShippingOption.create!(name: 'Outra Entrega', min_distance: 60 , max_distance: 700, min_weight: 3_000, max_weight: 55_000, 
                                  delivery_fee: 3.50)

      Price.create!(min_weight: 3_000, max_weight: 10_000, price_per_km: 6.00, shipping_option: so)

      # Act
      login_as user
      visit root_path
      click_on 'Preços'

      # Assert
      expect(page).not_to have_link 'Editar'
    end

    it 'pela url' do
      # Arrange
      user = User.create!(name: 'Pessoa', email: 'pessoa@sistemadefrete.com.br', password: 'password', role: :regular)

      so = ShippingOption.create!(name: 'Outra Entrega', min_distance: 60 , max_distance: 700, min_weight: 3_000, max_weight: 55_000, 
                                  delivery_fee: 3.50)

      price = Price.create!(min_weight: 3_000, max_weight: 10_000, price_per_km: 6.00, shipping_option: so)

      # Act
      login_as user
      visit edit_shipping_option_price_path(so.id, price.id)

      # Assert
      expect(current_path).to eq root_path
    end
  end

  it 'e não está autenticado' do
    # Arrange
    so = ShippingOption.create!(name: 'Outra Entrega', min_distance: 60 , max_distance: 700, min_weight: 3_000, max_weight: 55_000, 
                                delivery_fee: 3.50)

    price = Price.create!(min_weight: 3_000, max_weight: 10_000, price_per_km: 6.00, shipping_option: so)

    # Act
    visit edit_shipping_option_price_path(so.id, price.id)

    # Assert
    expect(current_path).to eq new_user_session_path
  end
end