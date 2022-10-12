require 'rails_helper'

describe 'Usuário altera o status de uma modalidade de transporte' do
  context 'para inativa' do
    it 'e não está autenticado' do
      # Arrange
      so = ShippingOption.create!(name: 'Entrega Expressa', min_distance: 50 , max_distance: 600, min_weight: 1000, max_weight: 50000, 
                                  delivery_fee: 5.50, status: :enabled)
  
      # Act
      post(disable_shipping_option_path(so.id))
  
      # Assert
      expect(response).to redirect_to(new_user_session_url)
    end

    it 'como usuário regular' do
      # Arrange
      user = User.create!(name: 'Pessoa', email: 'pessoa@sistemadefrete.com.br', password: 'password', role: :regular)
  
      so = ShippingOption.create!(name: 'Entrega Expressa', min_distance: 50 , max_distance: 600, min_weight: 1000, max_weight: 50000, 
                                  delivery_fee: 5.50, status: :enabled)
  
      # Act
      login_as user
      post(disable_shipping_option_path(so.id))
  
      # Assert
      expect(response).not_to redirect_to(shipping_option_path(so.id))
    end
  end

  context 'para ativa' do
    it 'e não está autenticado' do
      # Arrange
      so = ShippingOption.create!(name: 'Entrega Expressa', min_distance: 50 , max_distance: 600, min_weight: 1000, max_weight: 50000, 
                                  delivery_fee: 5.50, status: :disabled)
  
      # Act
      post(enable_shipping_option_path(so.id))
  
      # Assert
      expect(response).to redirect_to(new_user_session_url)
    end

    it 'como usuário regular' do
      # Arrange
      user = User.create!(name: 'Pessoa', email: 'pessoa@sistemadefrete.com.br', password: 'password', role: :regular)
  
      so = ShippingOption.create!(name: 'Entrega Expressa', min_distance: 50 , max_distance: 600, min_weight: 1000, max_weight: 50000, 
                                  delivery_fee: 5.50, status: :disabled)
  
      # Act
      login_as user
      post(enable_shipping_option_path(so.id))
  
      # Assert
      expect(response).not_to redirect_to(shipping_option_path(so.id))
    end
  end
end