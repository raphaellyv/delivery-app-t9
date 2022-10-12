require 'rails_helper'

describe 'Usuário cadastra um veículo' do
  it 'como usuário regular' do
    # Arrange
    user = User.create!(name: 'Pessoa', email: 'pessoa@sistemadefrete.com.br', password: 'password', role: :regular)
      
    ShippingOption.create!(name: 'Entrega Expressa', min_distance: 50 , max_distance: 600, min_weight: 1000, max_weight: 50_000, 
                           delivery_fee: 5.50, status: :enabled)

    # Act
    login_as user
    visit root_path
    click_on 'Veículos'

    # Assert
    expect(page).not_to have_content 'Novo Veículo'
    expect(page).not_to have_field 'Modalidade de Transporte'
    expect(page).not_to have_field 'Placa'
    expect(page).not_to have_field 'Marca'
    expect(page).not_to have_field 'Modelo'
    expect(page).not_to have_field 'Ano'
    expect(page).not_to have_field 'Carga Máxima'
    expect(page).not_to have_button 'Criar Veículo'
  end

  context 'como administrador' do
    it 'a partir da lista de veículos' do
      # Arrange
      admin = User.create!(name: 'Pessoa', email: 'pessoa@sistemadefrete.com.br', password: 'password', role: :admin)

      # Act
      login_as admin
      visit root_path
      click_on 'Veículos'

      # Assert
      expect(page).to have_content 'Novo Veículo'
      expect(page).to have_field 'Modalidade de Transporte'
      expect(page).to have_field 'Placa'
      expect(page).to have_field 'Marca'
      expect(page).to have_field 'Modelo'
      expect(page).to have_field 'Ano'
      expect(page).to have_field 'Carga Máxima'
      expect(page).to have_button 'Criar Veículo'
    end

    it 'com sucesso' do
      # Arrange
      admin = User.create!(name: 'Pessoa', email: 'pessoa@sistemadefrete.com.br', password: 'password', role: :admin)
      
      ShippingOption.create!(name: 'Entrega Expressa', min_distance: 50 , max_distance: 600, min_weight: 1000, max_weight: 50_000, 
                             delivery_fee: 5.50, status: :enabled)

      ShippingOption.create!(name: 'Outra Entrega', min_distance: 60 , max_distance: 700, min_weight: 3000, max_weight: 55_000, 
                             delivery_fee: 3.50, status: :enabled)

      # Act
      login_as admin
      visit root_path
      click_on 'Veículos'
      select 'Outra Entrega', from: 'Modalidade de Transporte'
      fill_in 'Placa', with: 'AAA0000'
      fill_in 'Marca', with: 'Peugeot'
      fill_in 'Modelo', with: 'Partner CS'
      fill_in 'Ano', with: '2021'
      fill_in 'Carga Máxima', with: '800000'
      click_on 'Criar Veículo'

      # Assert
      expect(page).to have_content 'Veículo cadastrado com sucesso'
      expect(page).to have_link 'Outra Entrega'
      expect(page).to have_content 'AAA0000'
      expect(page).to have_content 'Peugeot'
      expect(page).to have_content 'Partner CS'
      expect(page).to have_content '2021'
      expect(page).to have_content '800 kg'
      expect(page).to have_content 'Status'
      expect(page).to have_content 'Disponível'
    end

    it 'com dados incompletos' do
      # Arrange
      admin = User.create!(name: 'Pessoa', email: 'pessoa@sistemadefrete.com.br', password: 'password', role: :admin)

      ShippingOption.create!(name: 'Outra Entrega', min_distance: 60 , max_distance: 700, min_weight: 3000, max_weight: 55_000, 
                             delivery_fee: 3.50, status: :enabled)

      # Act
      login_as admin
      visit root_path
      click_on 'Veículos'
      fill_in 'Placa', with: ''
      fill_in 'Marca', with: ''
      fill_in 'Modelo', with: ''
      fill_in 'Ano', with: ''
      fill_in 'Carga Máxima', with: ''
      click_on 'Criar Veículo'

      # Assert
      expect(page).to have_content 'Não foi possível cadastrar o Veículo'
      expect(page).to have_content 'Placa não pode ficar em branco'
      expect(page).to have_content 'Marca não pode ficar em branco'
      expect(page).to have_content 'Modelo não pode ficar em branco'
      expect(page).to have_content 'Ano não pode ficar em branco'
      expect(page).to have_content 'Carga Máxima não pode ficar em branco'
    end
  end
end