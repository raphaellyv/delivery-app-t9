require 'rails_helper'

describe 'Usuário edita um prazo' do
  it 'e não está autenticado' do
    # Arrange
    so = ShippingOption.create!(name: 'Outra Entrega', min_distance: 60 , max_distance: 700, min_weight: 3_000, max_weight: 55_000, 
                                delivery_fee: 3.50)

    deadline = Deadline.create!(min_distance: 101, max_distance: 500, deadline: 48, shipping_option: so)

    # Act
    patch(shipping_option_deadline_path(so.id, deadline.id), params: { deadline: { min_distance: 100, max_distance: 400, deadline: 45 } })

    # Assert
    expect(response).to redirect_to(new_user_session_url)
  end

  it 'como usuário regular' do
    # Arrange
    user = User.create!(name: 'Pessoa', email: 'pessoa@sistemadefrete.com.br', password: 'password', role: :regular)

    so = ShippingOption.create!(name: 'Outra Entrega', min_distance: 60 , max_distance: 700, min_weight: 3_000, max_weight: 55_000, 
                                delivery_fee: 3.50)

    deadline = Deadline.create!(min_distance: 101, max_distance: 500, deadline: 48, shipping_option: so)

    # Act
    login_as user
    patch(shipping_option_deadline_path(so.id, deadline.id), params: { deadline: { min_distance: 100, max_distance: 400, deadline: 45 } })

    # Assert
    expect(response).to redirect_to(root_path)
  end
end
