require 'rails_helper'

describe 'Usuário vê lista de prazos' do
  context 'como administrador' do
    it 'com sucesso' do
      # Arrange
      admin = User.create!(name: 'Pessoa', email: 'pessoa@sistemadefrete.com.br', password: 'password', role: :admin)

      so_a = ShippingOption.create!(name: 'Entrega Expressa', min_distance: 50 , max_distance: 600, min_weight: 1000, max_weight: 50_000, 
                                    delivery_fee: 5.50)
      so_b = ShippingOption.create!(name: 'Outra Entrega', min_distance: 60 , max_distance: 700, min_weight: 3000, max_weight: 55_000, 
                                    delivery_fee: 3.50)

      Deadline.create!(min_distance: 101, max_distance: 500, deadline: 48, shipping_option: so_a)
      Deadline.create!(min_distance: 70, max_distance: 100, deadline: 30, shipping_option: so_b)

      # Act
      login_as admin
      visit root_path
      within 'nav' do
        click_on 'Prazos'
      end
      
      # Assert
      expect(page).to have_content 'Prazos'
      within 'main' do
        expect(page).to have_content 'Prazo de Entrega'
      end
      expect(page).to have_content '48 h'
      expect(page).to have_content '30 h'
      expect(page).to have_content 'Intervalo de Distância'
      expect(page).to have_content '70 km a 100 km'
      expect(page).to have_content '101 km a 500 km'
      expect(page).to have_content 'Modalidade de Transporte'
      expect(page).to have_link 'Entrega Expressa'
      expect(page).to have_link 'Outra Entrega'
    end

    it 'e não existem prazos cadastrados' do
      # Arrange
      admin = User.create!(name: 'Pessoa', email: 'pessoa@sistemadefrete.com.br', password: 'password', role: :admin)

      # Act
      login_as admin
      visit root_path
      click_on 'Prazos'

      # Assert
      expect(page).to have_content 'Não existem prazos de entrega cadastrados'
    end
  end

  context 'como usuário regular' do
    it 'com sucesso' do
      # Arrange
      user = User.create!(name: 'Pessoa', email: 'pessoa@sistemadefrete.com.br', password: 'password', role: :regular)

      so_a = ShippingOption.create!(name: 'Entrega Expressa', min_distance: 50 , max_distance: 600, min_weight: 1000, max_weight: 50_000, 
                                    delivery_fee: 5.50)
      so_b = ShippingOption.create!(name: 'Outra Entrega', min_distance: 60 , max_distance: 700, min_weight: 3000, max_weight: 55_000, 
                                    delivery_fee: 3.50)

      Deadline.create!(min_distance: 101, max_distance: 500, deadline: 48, shipping_option: so_a)
      Deadline.create!(min_distance: 70, max_distance: 100, deadline: 30, shipping_option: so_b)

      # Act
      login_as user
      visit root_path
      within 'nav' do
        click_on 'Prazos'
      end
      
      # Assert
      expect(page).to have_content 'Prazos'
      within 'main' do
        expect(page).to have_content 'Prazo de Entrega'
      end
      expect(page).to have_content '48 h'
      expect(page).to have_content '30 h'
      expect(page).to have_content 'Intervalo de Distância'
      expect(page).to have_content '70 km a 100 km'
      expect(page).to have_content '101 km a 500 km'
      expect(page).to have_content 'Modalidade de Transporte'
      expect(page).to have_link 'Entrega Expressa'
      expect(page).to have_link 'Outra Entrega'
    end

    it 'e não existem prazos cadastrados' do
      # Arrange
      user = User.create!(name: 'Pessoa', email: 'pessoa@sistemadefrete.com.br', password: 'password', role: :regular)

      # Act
      login_as user
      visit root_path
      click_on 'Prazos'

      # Assert
      expect(page).to have_content 'Não existem prazos de entrega cadastrados'
    end
  end

  context 'e não está autenticado' do
    it 'a partir do menu' do
      # Arrange

      # Act
      visit root_path

      # Assert
      expect(page).not_to have_content 'Prazos'
    end

    it 'pela url' do
      # Arrange

      # Act
      visit deadlines_path

      # Assert
      expect(current_path).to eq new_user_session_path
    end
  end
end