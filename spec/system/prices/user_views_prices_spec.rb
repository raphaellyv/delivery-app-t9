require 'rails_helper'

describe 'Usuário vê preços' do
  context 'como administrador' do
    it 'com sucesso' do
      # Arrange
      admin = User.create!(name: 'Pessoa', email: 'pessoa@sistemadefrete.com.br', password: 'password', role: :admin)
  
      so_a = ShippingOption.create!(name: 'Entrega Expressa', min_distance: 50 , max_distance: 600, min_weight: 1_000, max_weight: 50_000, 
                                    delivery_fee: 5.50)

      so_b = ShippingOption.create!(name: 'Outra Entrega', min_distance: 60 , max_distance: 700, min_weight: 3_000, max_weight: 55_000, 
                                    delivery_fee: 3.50)

      Price.create!(min_weight: 3_000, max_weight: 10_000, price_per_km: 6.00, shipping_option: so_a)

      Price.create!(min_weight: 4_000, max_weight: 10_000, price_per_km: 5.00, shipping_option: so_b)

      # Act
      login_as admin
      visit root_path
      within 'nav' do
        click_on 'Preços'
      end
      
      # Assert
      expect(current_path).to eq prices_path
      expect(page).to have_content 'Preços por km'
      expect(page).to have_content 'Modalidade de Transporte'
      expect(page).to have_link 'Entrega Expressa'
      expect(page).to have_link 'Outra Entrega'
      expect(page).to have_content 'Intervalo de Peso'
      expect(page).to have_content '3 kg a 10 kg'
      expect(page).to have_content '4 kg a 10 kg'
      expect(page).to have_content 'Preço por km'
      expect(page).to have_content 'R$ 6,00'
      expect(page).to have_content 'R$ 5,00'
    end

    it 'e não existem preços cadastrados' do
      # Arrange
      admin = User.create!(name: 'Pessoa', email: 'pessoa@sistemadefrete.com.br', password: 'password', role: :admin)
    
      # Act
      login_as admin
      visit root_path
      click_on 'Preços'

      # Assert
      expect(page).to have_content 'Não existem preços cadastrados'
    end
  end

  context 'como usuário regular' do
    it 'com sucesso' do
      # Arrange
      user = User.create!(name: 'Pessoa', email: 'pessoa@sistemadefrete.com.br', password: 'password', role: :regular)
  
      so_a = ShippingOption.create!(name: 'Entrega Expressa', min_distance: 50 , max_distance: 600, min_weight: 1_000, max_weight: 50_000, 
                                    delivery_fee: 5.50)

      so_b = ShippingOption.create!(name: 'Outra Entrega', min_distance: 60 , max_distance: 700, min_weight: 3_000, max_weight: 55_000, 
                                    delivery_fee: 3.50)

      Price.create!(min_weight: 3_000, max_weight: 10_000, price_per_km: 6.00, shipping_option: so_a)

      Price.create!(min_weight: 4_000, max_weight: 10_000, price_per_km: 5.00, shipping_option: so_b)

      # Act
      login_as user
      visit root_path
      within 'nav' do
        click_on 'Preços'
      end
      
      # Assert
      expect(current_path).to eq prices_path
      within 'main' do
        expect(page).to have_content 'Preços'
      end
      expect(page).to have_content 'Modalidade de Transporte'
      expect(page).to have_link 'Entrega Expressa'
      expect(page).to have_link 'Outra Entrega'
      expect(page).to have_content 'Intervalo de Peso'
      expect(page).to have_content '3 kg a 10 kg'
      expect(page).to have_content '4 kg a 10 kg'
      expect(page).to have_content 'Preço por km'
      expect(page).to have_content 'R$ 6,00'
      expect(page).to have_content 'R$ 5,00'
    end

    it 'e não existem preços cadastrados' do
      # Arrange
      user = User.create!(name: 'Pessoa', email: 'pessoa@sistemadefrete.com.br', password: 'password', role: :regular)
    
      # Act
      login_as user
      visit root_path
      click_on 'Preços'

      # Assert
      expect(page).to have_content 'Não existem preços cadastrados'
    end
  end

  context 'e não está autenticado' do
    it 'a partir do menu' do
      # Arrange

      # Act
      visit root_path

      # Assert
      expect(page).not_to have_content 'Preços'
    end

    it 'pela url' do
      # Arrange

      # Act
      visit prices_path

      # Assert
      expect(current_path).to eq new_user_session_path
    end
  end
end