require 'rails_helper'

describe 'Usuário cadastra uma taxa por distância' do
  it 'e não está autenticado' do
    # Arrange
    so = ShippingOption.create!(name: 'Outra Entrega', min_distance: 60 , max_distance: 700, min_weight: 3000, max_weight: 55_000, 
                                delivery_fee: 3.50)
    
    # Act
    post(shipping_option_distance_fees_path(so.id), params: { distance_fee: { min_distance: 101, max_distance: 500, fee: 2.00 } })

    # Assert
    expect(response).to redirect_to(new_user_session_url)
  end

  it 'como usuário regular' do
    # Arrange
    user = User.create!(name: 'Pessoa', email: 'pessoa@sistemadefrete.com.br', password: 'password', role: :regular)

    so = ShippingOption.create!(name: 'Outra Entrega', min_distance: 60 , max_distance: 700, min_weight: 3000, max_weight: 55_000, 
                                delivery_fee: 3.50)
    
    # Act
    login_as user
    post(shipping_option_distance_fees_path(so.id), params: { distance_fee: { min_distance: 101, max_distance: 500, fee: 2.00 } })

    # Assert
    expect(response).to redirect_to(root_url)
  end
end