require 'rails_helper'

describe 'Usuário vê taxas por distância' do
  context 'como administrador' do
    it 'com sucesso' do
      # Arrange
      admin = User.create!(name: 'Pessoa', email: 'pessoa@sistemadefrete.com.br', password: 'password', role: :admin)
  
      so_a = ShippingOption.create!(name: 'Entrega Expressa', min_distance: 50 , max_distance: 600, min_weight: 1_000, max_weight: 50_000, 
                                    delivery_fee: 5.50)

      so_b = ShippingOption.create!(name: 'Outra Entrega', min_distance: 60 , max_distance: 700, min_weight: 3_000, max_weight: 55_000, 
                                    delivery_fee: 3.50)

      DistanceFee.create!(min_distance: 50, max_distance: 200, fee: 7.00, shipping_option: so_a)
      DistanceFee.create!(min_distance: 201, max_distance: 400, fee: 4.00, shipping_option: so_a)

      DistanceFee.create!(min_distance: 70, max_distance: 300, fee: 3.00, shipping_option: so_b)

      # Act
      login_as admin
      visit root_path
      within 'nav' do
        click_on 'Preços'
      end
      
      # Assert
      expect(current_path).to eq prices_path
      expect(page).to have_content 'Taxas por Distância'
      expect(page).to have_content 'Intervalo de Distância'
      expect(page).to have_content '50 km a 200 km'
      expect(page).to have_content '201 km a 400 km'
      expect(page).to have_content '70 km a 300 km'
      expect(page).to have_content 'Taxa'
      expect(page).to have_content 'R$ 7,00'
      expect(page).to have_content 'R$ 4,00'
      expect(page).to have_content 'R$ 3,00'
    end

    it 'e não existem taxas cadastradas' do
      # Arrange
      admin = User.create!(name: 'Pessoa', email: 'pessoa@sistemadefrete.com.br', password: 'password', role: :admin)

      # Act
      login_as admin
      visit root_path
      within 'nav' do
        click_on 'Preços'
      end
      
      # Assert
      expect(current_path).to eq prices_path
      expect(page).to have_content 'Taxas por Distância'
      expect(page).to have_content 'Não existem taxas por distância cadastradas'
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

      DistanceFee.create!(min_distance: 50, max_distance: 200, fee: 7.00, shipping_option: so_a)
      DistanceFee.create!(min_distance: 201, max_distance: 400, fee: 4.00, shipping_option: so_a)

      DistanceFee.create!(min_distance: 70, max_distance: 300, fee: 3.00, shipping_option: so_b)

      # Act
      login_as user
      visit root_path
      within 'nav' do
        click_on 'Preços'
      end
      
      # Assert
      expect(current_path).to eq prices_path
      expect(page).to have_content 'Taxas por Distância'
      expect(page).to have_content 'Intervalo de Distância'
      expect(page).to have_content '50 km a 200 km'
      expect(page).to have_content '201 km a 400 km'
      expect(page).to have_content '70 km a 300 km'
      expect(page).to have_content 'Taxa'
      expect(page).to have_content 'R$ 7,00'
      expect(page).to have_content 'R$ 4,00'
      expect(page).to have_content 'R$ 3,00'
    end

    it 'e não existem taxas cadastradas' do
      # Arrange
      user = User.create!(name: 'Pessoa', email: 'pessoa@sistemadefrete.com.br', password: 'password', role: :regular)

      # Act
      login_as user
      visit root_path
      within 'nav' do
        click_on 'Preços'
      end
      
      # Assert
      expect(current_path).to eq prices_path
      expect(page).to have_content 'Taxas por Distância'
      expect(page).to have_content 'Não existem taxas por distância cadastradas'
    end
  end
end