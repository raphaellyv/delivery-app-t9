require 'rails_helper'

describe 'Usuário edita uma modalidade de transporte' do
  it 'e não está autenticado' do
    # Arrange
    so = ShippingOption.create!(name: 'Entrega Expressa', min_distance: 50 , max_distance: 600, min_weight: 1000, max_weight: 50000, 
                                delivery_fee: 5.50, status: :enabled)

    # Act
    patch(shipping_option_path(so.id), params: { shipping_option: { name: 'Entrega Rápida' } })

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
    patch(shipping_option_path(so.id), params: { shipping_option: { name: 'Entrega Rápida' } })

    # Assert
    expect(response).not_to redirect_to(shipping_option_path(so.id))
  end
end