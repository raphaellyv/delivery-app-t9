require 'rails_helper'

RSpec.describe User, type: :model do
  describe '#valid?' do
    context 'presence' do
      it 'nome é obrigatório' do
        # Arrange
        user = User.new(name: '')
  
        # Act
        user.valid?
  
        # Assert
        expect(user.errors.include? :name).to be true
      end

      it 'e-mail é obrigatório' do
        # Arrange
        user = User.new(email:'')
  
        # Act
        user.valid?
  
        # Assert
        expect(user.errors.include? :email).to be true
      end

      it 'senha é obrigatória' do
        # Arrange
        user = User.new(password: '')
  
        # Act
        user.valid?
  
        # Assert
        expect(user.errors.include? :password).to be true
      end
    end
    
    context 'unique' do
      it 'e-mail é único' do
        # Arrange
        User.create!(name: 'Pessoa', email:'pessoa@sistemadefrete.com.br', password: 'password')
        user = User.new(email:'pessoa@sistemadefrete.com.br')
  
        # Act
        user.valid?
  
        # Assert
        expect(user.errors.include? :email).to be true
      end
    end

    context 'format' do
      it 'e-mail deve terminar em @sistemadefrete.com.br' do
        # Arrange
        user = User.new(email:'pessoa@email.com.br') 

        # Act
        user.valid?

        # Assert
        expect(user.errors.include? :email).to be true
      end
    end
  end
  describe '#regular?' do
    it 'o usuário é regular por padrão' do
      # Arrange
      user = User.create!(name: 'Pessoa', email: 'pessoa@sistemadefrete.com.br', password: 'password')

      # Act

      # Assert
      expect(user.regular?).to be true
    end
  end
end
