require 'rails_helper'

describe 'Usuário regular se cadastra' do
  it 'com sucesso' do
    # Arrange

    # Act
    visit root_path
    click_on 'Entrar'
    click_on 'Cadastre-se'
    fill_in 'Nome', with: 'Pessoa'
    fill_in 'E-mail', with: 'pessoa@sistemadefrete.com.br'
    fill_in 'Senha', with: 'password'
    fill_in 'Confirme sua senha', with: 'password'
    click_on 'Criar conta'


    # Assert
    expect(page).to have_content 'Pessoa'
    expect(page).to have_button 'Sair'
    expect(page).to have_content 'Boas vindas! Você realizou seu registro com sucesso.'
  end

  it 'com dados incompletos' do
    # Arrange

    # Act
    visit root_path
    click_on 'Entrar'
    click_on 'Cadastre-se'
    fill_in 'Nome', with: ''
    fill_in 'E-mail', with: ''
    fill_in 'Senha', with: ''
    fill_in 'Confirme sua senha', with: ''
    click_on 'Criar conta'

    # Assert
    expect(page).to have_content 'Nome não pode ficar em branco'
    expect(page).to have_content 'E-mail não pode ficar em branco'
    expect(page).to have_content 'E-mail não é válido'
    expect(page).to have_content 'Senha não pode ficar em branco'
    expect(page).to have_content 'Não foi possível salvar usuário: 4 erros.'
  end
end