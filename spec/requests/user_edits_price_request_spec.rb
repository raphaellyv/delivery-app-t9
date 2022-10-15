require 'rails_helper'

describe 'Usuário edita um preço' do
  it 'e não está autenticado' do
    # Arrange
    so = ShippingOption.create!(name: 'Outra Entrega', min_distance: 60 , max_distance: 700, min_weight: 3_000, max_weight: 55_000, 
                                delivery_fee: 3.50)

    price = Price.create!(min_weight: 3_000, max_weight: 10_000, price_per_km: 6.00, shipping_option: so)

    # Act
    patch(shipping_option_price_path(so.id, price.id), params: { price: { min_weight: 3_500, max_weight: 10_500, price_per_km: 3.00 } })

    # Assert
    expect(response).to redirect_to(new_user_session_url)
  end

  it 'como usuário regular' do
    # Arrange
    user = User.create!(name: 'Pessoa', email: 'pessoa@sistemadefrete.com.br', password: 'password', role: :regular)

    so = ShippingOption.create!(name: 'Outra Entrega', min_distance: 60 , max_distance: 700, min_weight: 3_000, max_weight: 55_000, 
                                delivery_fee: 3.50)

    price = Price.create!(min_weight: 3_000, max_weight: 10_000, price_per_km: 6.00, shipping_option: so)

    # Act
    login_as user
    patch(shipping_option_price_path(so.id, price.id), params: { price: { min_weight: 3_500, max_weight: 10_500, price_per_km: 3.00 } })

    # Assert
    expect(response).to redirect_to(root_path)
  end
end