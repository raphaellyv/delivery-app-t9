require 'rails_helper'

describe 'Usuário ativa modalidade de transporte' do
  it 'e não deve ser um usuário regular' do
    # Arrange
    user = User.create!(name: 'Pessoa', email: 'pessoa@sistemadefrete.com.br', password: 'password', role: :regular)

    ShippingOption.create!(name: 'Entrega Expressa', min_distance: 50 , max_distance: 600, min_weight: 1000, max_weight: 50000, 
                           delivery_fee: 5.50)

    # Act
    login_as user
    visit root_path
    click_on 'Modalidades de Transporte'

    # Assert
    expect(page).not_to have_content 'Alterar Status'
    expect(page).not_to have_button 'Ativar'
    expect(page).not_to have_button 'Desativar'
  end

  context 'como administrador' do
    it 'a partir da lista de modalidades de transporte' do
      # Arrange
      admin = User.create!(name: 'Pessoa', email: 'pessoa@sistemadefrete.com.br', password: 'password', role: :admin)

      ShippingOption.create!(name: 'Entrega Expressa', min_distance: 50 , max_distance: 600, min_weight: 1000, max_weight: 50000, 
                             delivery_fee: 5.50)

      # Act
      login_as admin
      visit root_path
      click_on 'Modalidades de Transporte'

      # Assert
      expect(page).to have_button 'Ativar'
      expect(page).not_to have_button 'Desativar'
    end

    it 'com sucesso' do
      # Arrange
      admin = User.create!(name: 'Pessoa', email: 'pessoa@sistemadefrete.com.br', password: 'password', role: :admin)

      so = ShippingOption.create!(name: 'Entrega Expressa', min_distance: 50 , max_distance: 600, min_weight: 1000, max_weight: 50000, 
                                  delivery_fee: 5.50)

      # Act
      login_as admin
      visit root_path
      click_on 'Modalidades de Transporte'
      click_on 'Ativar'

      # Assert
      expect(page).to have_content 'Modalidade de Transporte ativada com sucesso'
      expect(page).to have_button 'Desativar'
    end
  end
end