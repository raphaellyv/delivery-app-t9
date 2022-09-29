require 'rails_helper'

RSpec.describe User, type: :model do
  describe '#valid?' do
    context 'presence' do
      it 'nome é obrigatório' do
        # Arrange
        user = User.new(name: '', email:'pessoa@sistemadefrete.com.br', password: 'password')
  
        # Act
  
        # Assert
        expect(user.valid?).to eq false
      end

      it 'e-mail é obrigatório' do
        # Arrange
        user = User.new(name: 'Pessoa', email:'', password: 'password')
  
        # Act
  
        # Assert
        expect(user.valid?).to eq false
      end

      it 'senha é obrigatória' do
        # Arrange
        user = User.new(name: 'Pessoa', email:'pessoa@sistemadefrete.com.br', password: '')
  
        # Act
  
        # Assert
        expect(user.valid?).to eq false
      end
    end
    
    context 'unique' do
      it 'e-mail é único' do
        # Arrange
        User.create!(name: 'Pessoa', email:'pessoa@sistemadefrete.com.br', password: 'password')
        user = User.new(name: 'Outra Pessoa', email:'pessoa@sistemadefrete.com.br', password: 'password2')
  
        # Act
  
        # Assert
        expect(user.valid?).to eq false
      end
    end

    context 'format' do
      it 'e-mail deve terminar em @sistemadefrete.com.br' do
        # Arrange
        user = User.new(name: 'Pessoa', email:'pessoa@email.com.br', password: 'password') 

        # Act

        # Assert
        expect(user.valid?).to eq false
      end
    end
  end
end
