require 'rails_helper'

describe 'Visitante vê a tela inicial' do
  it 'com sucesso' do
    # Arrange

    # Act
    visit root_path

    # Assert
    within 'nav' do
      expect(page).to have_link 'Sistema de Frete'
    end
    expect(page).to have_content 'Consulte seu pedido'
    expect(page).not_to have_link 'Ordens de Serviço'
  end
end