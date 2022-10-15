require 'rails_helper'

describe 'Usuário edita prazo' do
  context 'como administrador' do
    it 'a partir da lista de prazos' do
      # Arrange
      admin = User.create!(name: 'Pessoa', email: 'pessoa@sistemadefrete.com.br', password: 'password', role: :admin)

      so = ShippingOption.create!(name: 'Outra Entrega', min_distance: 60 , max_distance: 700, min_weight: 3_000, max_weight: 55_000, 
                                  delivery_fee: 3.50)

      Deadline.create!(min_distance: 101, max_distance: 500, deadline: 48, shipping_option: so)

      # Act
      login_as admin
      visit root_path
      click_on 'Prazos'
      click_on 'Editar'

      # Assert
      expect(page).to have_content 'Editar Prazo'
      expect(page).to have_content 'Modalidade de Transporte: Outra Entrega'
      expect(page).to have_content 'Intervalo de Distância: 60 km a 700 km'
      expect(page).to have_content '101 km a 500 km'
      expect(page).to have_content '48 h'
      expect(page).to have_field 'Distância Mínima', with: '101'
      expect(page).to have_field 'Distância Máxima', with: '500'
      expect(page).to have_field 'Prazo de Entrega', with: '48'
      expect(page).to have_button 'Atualizar Prazo'
    end

    it 'com sucesso' do
      # Arrange
      admin = User.create!(name: 'Pessoa', email: 'pessoa@sistemadefrete.com.br', password: 'password', role: :admin)

      so = ShippingOption.create!(name: 'Outra Entrega', min_distance: 60 , max_distance: 700, min_weight: 3_000, max_weight: 55_000, 
                                  delivery_fee: 3.50)

      Deadline.create!(min_distance: 101, max_distance: 500, deadline: 48, shipping_option: so)

      # Act
      login_as admin
      visit root_path
      click_on 'Prazos'
      click_on 'Editar'
      fill_in 'Distância Mínima', with: '100'
      fill_in 'Distância Máxima', with: '400'
      fill_in 'Prazo de Entrega', with: '45'
      click_on 'Atualizar Prazo' 

      # Assert
      expect(page).to have_content 'Prazo atualizado com sucesso'
      expect(page).to have_content 'Modalidade Outra Entrega'
      expect(page).to have_content 'Intervalo de Distância: 60 km a 700 km'
      expect(page).to have_content '100 km a 400 km'
      expect(page).to have_content '45 h'
    end

    it 'com campos incompletos' do
      # Arrange
      admin = User.create!(name: 'Pessoa', email: 'pessoa@sistemadefrete.com.br', password: 'password', role: :admin)

      so = ShippingOption.create!(name: 'Outra Entrega', min_distance: 60 , max_distance: 700, min_weight: 3_000, max_weight: 55_000, 
                                  delivery_fee: 3.50)

      Deadline.create!(min_distance: 101, max_distance: 500, deadline: 48, shipping_option: so)

      # Act
      login_as admin
      visit root_path
      click_on 'Prazos'
      click_on 'Editar'
      fill_in 'Distância Mínima', with: ''
      fill_in 'Distância Máxima', with: ''
      fill_in 'Prazo de Entrega', with: ''
      click_on 'Atualizar Prazo' 

      # Assert
      expect(page).to have_content 'Não foi possível atualizar o Prazo'
      expect(page).to have_content 'Distância Mínima não pode ficar em branco'
      expect(page).to have_content 'Distância Máxima não pode ficar em branco'
      expect(page).to have_content 'Prazo de Entrega não pode ficar em branco'
    end
  end

  context 'como usuário regular' do
    it 'a partir da lista de prazos' do
      # Arrange
      user = User.create!(name: 'Pessoa', email: 'pessoa@sistemadefrete.com.br', password: 'password', role: :regular)

      so = ShippingOption.create!(name: 'Outra Entrega', min_distance: 60 , max_distance: 700, min_weight: 3_000, max_weight: 55_000, 
                                  delivery_fee: 3.50)

      Deadline.create!(min_distance: 101, max_distance: 500, deadline: 48, shipping_option: so)

      # Act
      login_as user
      visit root_path
      click_on 'Prazos'

      # Assert
      expect(page).not_to have_link 'Editar'
    end

    it 'pela url' do
      # Arrange
      user = User.create!(name: 'Pessoa', email: 'pessoa@sistemadefrete.com.br', password: 'password', role: :regular)

      so = ShippingOption.create!(name: 'Outra Entrega', min_distance: 60 , max_distance: 700, min_weight: 3_000, max_weight: 55_000, 
                                  delivery_fee: 3.50)

      deadline = Deadline.create!(min_distance: 101, max_distance: 500, deadline: 48, shipping_option: so)

      # Act
      login_as user
      visit edit_shipping_option_deadline_path(so.id, deadline.id)

      # Assert
      expect(current_path).to eq root_path
    end
  end

  it 'e não está autenticado' do
    # Arrange
    so = ShippingOption.create!(name: 'Outra Entrega', min_distance: 60 , max_distance: 700, min_weight: 3_000, max_weight: 55_000, 
                                delivery_fee: 3.50)

    deadline = Deadline.create!(min_distance: 101, max_distance: 500, deadline: 48, shipping_option: so)

    # Act
    visit edit_shipping_option_deadline_path(so.id, deadline.id)

    # Assert
    expect(current_path).to eq new_user_session_path
  end
end