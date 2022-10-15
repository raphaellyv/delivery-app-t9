require 'rails_helper'

describe 'Usuário cadastra uma ordem de serviço' do
  it 'e não está autenticado' do
    # Arrange

    # Act
    post(orders_path, params: { order: { delivery_address: 'Rua das Palmeiras, 13', delivery_city: 'Rio de Janeiro', delivery_state: 'RJ', 
                                         delivery_postal_code: '28200000', recipient: 'Denise Silva', recipient_cpf: '00000000000',
                                         recipient_email: 'denise@email.com', recipient_phone_number: '2297523040', 
                                         pick_up_address: 'Estrada do Porto, 70', pick_up_city: 'São Paulo', pick_up_state: 'SP', 
                                         pick_up_postal_code: '30000000', sku: 'TV32P-SAMSUNG-XPTO90', height: 60, width: 40, length: 100, 
                                         weight: 3000, distance: 300 } })

    # Assert
    expect(response).to redirect_to(new_user_session_url)
  end

  it 'como usuário regular' do
    # Arrange
    user = User.create!(name: 'Pessoa', email: 'pessoa@sistemadefrete.com.br', password: 'password', role: :regular)

    # Act
    login_as user
    post(orders_path, params: { order: { delivery_address: 'Rua das Palmeiras, 13', delivery_city: 'Rio de Janeiro', delivery_state: 'RJ', 
                                         delivery_postal_code: '28200000', recipient: 'Denise Silva', recipient_cpf: '00000000000',
                                         recipient_email: 'denise@email.com', recipient_phone_number: '2297523040', 
                                         pick_up_address: 'Estrada do Porto, 70', pick_up_city: 'São Paulo', pick_up_state: 'SP', 
                                         pick_up_postal_code: '30000000', sku: 'TV32P-SAMSUNG-XPTO90', height: 60, width: 40, length: 100, 
                                         weight: 3000, distance: 300 } })

    # Assert
    expect(response).to redirect_to(root_path)
  end
end