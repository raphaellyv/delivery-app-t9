require 'rails_helper'

describe 'Usuário cadastra modalidade de transporte' do
  it 'como usuário regular' do
    # Arrange
    user = User.create!(name: 'Pessoa', email: 'pessoa@sistemadefrete.com.br', password: 'password', role: :regular)

    # Act
    login_as user
    visit root_path
    click_on 'Modalidades de Transporte'

    # Assert
    expect(page).not_to have_content 'Nova Modalidade de Transporte'
    expect(page).not_to have_field 'Modalidade'
    expect(page).not_to have_field 'Distância Mínima'
    expect(page).not_to have_field 'Distância Máxima'
    expect(page).not_to have_field 'Peso Mínimo'
    expect(page).not_to have_field 'Peso Máximo'
    expect(page).not_to have_field 'Taxa Fixa de Entrega'
    expect(page).not_to have_button 'Criar Modalidade de Transporte'
  end

  context 'como administrador' do
    it 'a partir da lista de modalidades de transporte' do
      # Arrange
      admin = User.create!(name: 'Pessoa', email: 'pessoa@sistemadefrete.com.br', password: 'password', role: :admin)

      # Act
      login_as admin
      visit root_path
      click_on 'Modalidades de Transporte'
  
      # Assert
      expect(page).to have_content 'Nova Modalidade de Transporte'
      expect(page).to have_field 'Modalidade'
      expect(page).to have_field 'Distância Mínima'
      expect(page).to have_field 'Distância Máxima'
      expect(page).to have_field 'Peso Mínimo'
      expect(page).to have_field 'Peso Máximo'
      expect(page).to have_field 'Taxa Fixa de Entrega'
      expect(page).to have_button 'Criar Modalidade de Transporte'
    end

    it 'com sucesso' do
      # Arrange
      admin = User.create!(name: 'Pessoa', email: 'pessoa@sistemadefrete.com.br', password: 'password', role: :admin)

      # Act
      login_as admin
      visit root_path
      click_on 'Modalidades de Transporte'
      fill_in 'Modalidade', with: 'Entrega Rápida'
      fill_in 'Distância Mínima', with: 50
      fill_in 'Distância Máxima', with: 600
      fill_in 'Peso Mínimo', with: 1000
      fill_in 'Peso Máximo', with: 50000
      fill_in 'Taxa Fixa de Entrega', with: 5.5
      click_on 'Criar Modalidade de Transporte'
  
      # Assert
      expect(page).to have_content 'Modalidade de Transporte cadastrada com sucesso'
      expect(page).to have_content '50 km a 600 km'
      expect(page).to have_content '1 kg a 50 kg'
      expect(page).to have_content 'R$ 5,50'
      expect(page).to have_content 'Entrega Rápida'
    end

    it 'com dados incompletos' do
      # Arrange
      admin = User.create!(name: 'Pessoa', email: 'pessoa@sistemadefrete.com.br', password: 'password', role: :admin)

      # Act
      login_as admin
      visit root_path
      click_on 'Modalidades de Transporte'
      fill_in 'Modalidade', with: ''
      fill_in 'Distância Mínima', with: ''
      fill_in 'Distância Máxima', with: ''
      fill_in 'Peso Mínimo', with: ''
      fill_in 'Peso Máximo', with: ''
      fill_in 'Taxa Fixa de Entrega', with: ''
      click_on 'Criar Modalidade de Transporte'
  
      # Assert
      expect(page).to have_content 'Não foi possível cadastrar a modalidade de transporte'
      expect(page).to have_content 'Modalidade não pode ficar em branco'
      expect(page).to have_content 'Distância Mínima não pode ficar em branco'
      expect(page).to have_content 'Distância Máxima não pode ficar em branco'
      expect(page).to have_content 'Peso Mínimo não pode ficar em branco'
      expect(page).to have_content 'Peso Máximo não pode ficar em branco'
      expect(page).to have_content 'Taxa Fixa de Entrega não pode ficar em branco'
    end
  end
end