require 'rails_helper'

describe 'Usuário vê detalhes de uma modalidade de transporte' do
  it 'como administrador' do
    # Arrange
    admin = User.create!(name: 'Pessoa', email: 'pessoa@sistemadefrete.com.br', password: 'password', role: :admin)

    so = ShippingOption.create!(name: 'Entrega Expressa', min_distance: 50 , max_distance: 600, min_weight: 1_000, max_weight: 50_000, 
                                delivery_fee: 5.50, status: :enabled)

    # Act
    login_as admin
    visit root_path
    click_on 'Modalidades de Transporte'
    click_on 'Entrega Expressa'

    # Assert
    expect(current_path).to eq shipping_option_path(so.id)
    expect(page).to have_content 'Modalidade Entrega Expressa'
    expect(page).to have_content 'Status: Ativa'
    expect(page).to have_content 'Intervalo de Distância: 50 km a 600 km'
    expect(page).to have_content 'Intervalo de Peso: 1 kg a 50 kg'
    expect(page).to have_content 'Taxa Fixa de Entrega: R$ 5,50'
  end

  it 'como usuário regular' do
    # Arrange
    user = User.create!(name: 'Pessoa', email: 'pessoa@sistemadefrete.com.br', password: 'password', role: :regular)

    so = ShippingOption.create!(name: 'Entrega Expressa', min_distance: 50 , max_distance: 600, min_weight: 1_000, max_weight: 50_000, 
                                delivery_fee: 5.50, status: :enabled)

    # Act
    login_as user
    visit root_path
    click_on 'Modalidades de Transporte'
    click_on 'Entrega Expressa'

    # Assert
    expect(current_path).to eq shipping_option_path(so.id)
    expect(page).to have_content 'Modalidade Entrega Expressa'
    expect(page).to have_content 'Status: Ativa'
    expect(page).to have_content 'Intervalo de Distância: 50 km a 600 km'
    expect(page).to have_content 'Intervalo de Peso: 1 kg a 50 kg'
    expect(page).to have_content 'Taxa Fixa de Entrega: R$ 5,50'
  end

  it 'e não está autenticado' do
    # Arrange
    so = ShippingOption.create!(name: 'Entrega Expressa', min_distance: 50 , max_distance: 600, min_weight: 1_000, max_weight: 50_000, 
                                delivery_fee: 5.50, status: :enabled)

    # Act
    visit shipping_option_path(so.id)

    # Assert
    expect(current_path).to eq new_user_session_path
  end
end