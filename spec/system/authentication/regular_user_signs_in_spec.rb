require 'rails_helper'

describe 'Usuário Regular se autentica' do
  it 'com sucesso' do
    # Arrange
    User.create!(name: 'Pessoa', email: 'pessoa@sistemadefrete.com.br', password: 'password')

    # Act
    visit root_path
    within 'nav' do
      click_on 'Entrar'
    end
    within 'form' do
      fill_in 'E-mail', with: 'pessoa@sistemadefrete.com.br'
      fill_in 'Senha', with: 'password'
      click_on 'Entrar'
    end

    # Assert
    within 'nav' do
      expect(page).not_to have_link 'Entrar'
      expect(page).to have_button 'Sair'
      expect(page).to have_content 'Pessoa'
    end
      expect(page).to have_content 'Login efetuado com sucesso.'
  end

  it 'e faz logout' do
    # Arrange
    User.create!(name: 'Pessoa', email: 'pessoa@sistemadefrete.com.br', password: 'password')

    # Act
    visit root_path
    within 'nav' do
      click_on 'Entrar'
    end
    within 'form' do
      fill_in 'E-mail', with: 'pessoa@sistemadefrete.com.br'
      fill_in 'Senha', with: 'password'
      click_on 'Entrar'
    end
    within 'nav' do
      click_on 'Pessoa'
      click_on 'Sair'
    end
    
    # Assert
    within 'nav' do
      expect(page).not_to have_button 'Sair'
      expect(page).to have_link 'Entrar'
    end
    expect(page).to have_content 'Logout efetuado com sucesso.'
  end
end