require 'rails_helper'

describe 'Usuário edita taxa por distância' do
  context 'como administrador' do
    it 'a partir da lista de taxas por distância' do
      # Arrange
      admin = User.create!(name: 'Pessoa', email: 'pessoa@sistemadefrete.com.br', password: 'password', role: :admin)

      so = ShippingOption.create!(name: 'Outra Entrega', min_distance: 60 , max_distance: 700, min_weight: 3_000, max_weight: 55_000, 
                                  delivery_fee: 3.50)

      DistanceFee.create!(min_distance: 60, max_distance: 200, fee: 7.00, shipping_option: so)

      # Act
      login_as admin
      visit root_path
      click_on 'Preços'
      click_on 'Editar'

      # Assert
      expect(page).to have_content 'Editar Taxa por Distância'
      expect(page).to have_content 'Modalidade de Transporte: Outra Entrega'
      expect(page).to have_content 'Intervalo de Distância: 60 km a 700 km'
      expect(page).to have_content '60 km a 200 km'
      expect(page).to have_content 'R$ 7,00'
      expect(page).to have_field 'Distância Mínima', with: '60'
      expect(page).to have_field 'Distância Máxima', with: '200'
      expect(page).to have_field 'Taxa', with: 7.00
      expect(page).to have_button 'Atualizar Taxa por Distância'
    end

    it 'com sucesso' do
      # Arrange
      admin = User.create!(name: 'Pessoa', email: 'pessoa@sistemadefrete.com.br', password: 'password', role: :admin)

      so = ShippingOption.create!(name: 'Outra Entrega', min_distance: 60 , max_distance: 700, min_weight: 3_000, max_weight: 55_000, 
                                  delivery_fee: 3.50)

      DistanceFee.create!(min_distance: 60, max_distance: 200, fee: 7.00, shipping_option: so)

      # Act
      login_as admin
      visit root_path
      click_on 'Preços'
      click_on 'Editar'
      fill_in 'Distância Mínima', with: '70'
      fill_in 'Distância Máxima', with: '90'
      fill_in 'Taxa', with: 5.00
      click_on 'Atualizar Taxa por Distância'

      # Assert
      expect(page).to have_content 'Taxa por Distância atualizada com sucesso'
      expect(page).to have_content 'Modalidade Outra Entrega'
      expect(page).to have_content 'Intervalo de Distância: 60 km a 700 km'
      expect(page).to have_content '70 km a 90 km'
      expect(page).to have_content 'R$ 5,00'
    end

    it 'com dados incompletos' do
      # Arrange
      admin = User.create!(name: 'Pessoa', email: 'pessoa@sistemadefrete.com.br', password: 'password', role: :admin)

      so = ShippingOption.create!(name: 'Outra Entrega', min_distance: 60 , max_distance: 700, min_weight: 3_000, max_weight: 55_000, 
                                  delivery_fee: 3.50)

      DistanceFee.create!(min_distance: 60, max_distance: 200, fee: 7.00, shipping_option: so)

      # Act
      login_as admin
      visit root_path
      click_on 'Preços'
      click_on 'Editar'
      fill_in 'Distância Mínima', with: ''
      fill_in 'Distância Máxima', with: ''
      fill_in 'Taxa', with: ''
      click_on 'Atualizar Taxa por Distância'

      # Assert
      expect(page).to have_content 'Não foi possível atualizar a Taxa por Distância'
      expect(page).to have_content 'Distância Mínima não pode ficar em branco'
      expect(page).to have_content 'Distância Máxima não pode ficar em branco'
      expect(page).to have_content 'Taxa não pode ficar em branco'
    end
  end

  context 'como usuário regular' do
    it 'a partir da lista de taxas por distância' do
      # Arrange
      user = User.create!(name: 'Pessoa', email: 'pessoa@sistemadefrete.com.br', password: 'password', role: :regular)

      so = ShippingOption.create!(name: 'Outra Entrega', min_distance: 60 , max_distance: 700, min_weight: 3_000, max_weight: 55_000, 
                                  delivery_fee: 3.50)

      DistanceFee.create!(min_distance: 60, max_distance: 200, fee: 7.00, shipping_option: so)

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

      distance_fee = DistanceFee.create!(min_distance: 60, max_distance: 200, fee: 7.00, shipping_option: so)

      # Act
      login_as user
      visit edit_shipping_option_distance_fee_path(so.id, distance_fee.id)

      # Assert
      expect(current_path).to eq root_path
    end
  end

  it 'e não está autenticado' do
    # Arrange
    so = ShippingOption.create!(name: 'Outra Entrega', min_distance: 60 , max_distance: 700, min_weight: 3_000, max_weight: 55_000, 
                                delivery_fee: 3.50)

    distance_fee = DistanceFee.create!(min_distance: 60, max_distance: 200, fee: 7.00, shipping_option: so)

    # Act
    visit edit_shipping_option_distance_fee_path(so.id, distance_fee.id)

    # Assert
    expect(current_path).to eq new_user_session_path
  end
end