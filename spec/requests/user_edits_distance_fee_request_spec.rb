require 'rails_helper'

describe 'Usuário edita uma taxa por distância' do
  it 'e não está autenticado' do
    # Arrange
    so = ShippingOption.create!(name: 'Outra Entrega', min_distance: 60 , max_distance: 700, min_weight: 3_000, max_weight: 55_000, 
                                delivery_fee: 3.50)

    distance_fee = DistanceFee.create!(min_distance: 60, max_distance: 200, fee: 7.00, shipping_option: so)

    # Act
    patch(shipping_option_distance_fee_path(so.id, distance_fee.id), 
          params: { distance_fee: { min_distance: 70, max_distance: 90, fee: 3.00 } })

    # Assert
    expect(response).to redirect_to(new_user_session_url)
  end

  it 'como usuário regular' do
    # Arrange
    user = User.create!(name: 'Pessoa', email: 'pessoa@sistemadefrete.com.br', password: 'password', role: :regular)

    so = ShippingOption.create!(name: 'Outra Entrega', min_distance: 60 , max_distance: 700, min_weight: 3_000, max_weight: 55_000, 
                                delivery_fee: 3.50)

    distance_fee = DistanceFee.create!(min_distance: 60, max_distance: 200, fee: 7.00, shipping_option: so)

    # Act
    login_as user
    patch(shipping_option_distance_fee_path(so.id, distance_fee.id), 
          params: { distance_fee: { min_distance: 70, max_distance: 90, fee: 3.00 } })

    # Assert
    expect(response).to redirect_to(root_path)
  end
end