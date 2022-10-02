require 'rails_helper'

RSpec.describe Order, type: :model do
  describe '#pending?' do
    it 'a ordem de serviço é criada como pendente' do
      # Arrange
      order = Order.create!(delivery_address: 'Rua das Palmeiras, 13', delivery_city: 'Rio de Janeiro', delivery_state: 'RJ', 
                            delivery_postal_code: '28200000', recipient: 'Denise Silva', recipient_cpf: '00000000000',
                            recipient_email: 'denise@email.com', recipient_phone_number: '00000000000', 
                            pick_up_address: 'Estrada do Porto, 70', pick_up_city: 'São Paulo', pick_up_state: 'SP', 
                            pick_up_postal_code: '30000000', sku: '00000000000000000000', height: 60, width: 40, length: 100, 
                            weight: 300, distance: 60)

      # Act
      
      # Assert
      expect(order.pending?).to be true
    end
  end

  describe 'gera um código aleatório' do
    it 'ao criar uma ordem de serviço' do
      # Arrange
      order = Order.create!(delivery_address: 'Rua das Palmeiras, 13', delivery_city: 'Rio de Janeiro', delivery_state: 'RJ', 
                            delivery_postal_code: '28200000', recipient: 'Denise Silva', recipient_cpf: '00000000000',
                            recipient_email: 'denise@email.com', recipient_phone_number: '00000000000', 
                            pick_up_address: 'Estrada do Porto, 70', pick_up_city: 'São Paulo', pick_up_state: 'SP', 
                            pick_up_postal_code: '30000000', sku: '00000000000000000000', height: 60, width: 40, length: 100, 
                            weight: 300, distance: 60)
      
      # Act

      # Assert
      expect(order.tracking_code.length).to eq 15
    end

    it 'e o código é único' do
      # Arrange
      first_order = Order.create!(delivery_address: 'Rua das Palmeiras, 13', delivery_city: 'Rio de Janeiro', delivery_state: 'RJ', 
                                  delivery_postal_code: '28200000', recipient: 'Denise Silva', recipient_cpf: '00000000000',
                                  recipient_email: 'denise@email.com', recipient_phone_number: '00000000000', 
                                  pick_up_address: 'Estrada do Porto, 70', pick_up_city: 'São Paulo', pick_up_state: 'SP', 
                                  pick_up_postal_code: '30000000', sku: '00000000000000000000', height: 60, width: 40, length: 100, 
                                  weight: 300, distance: 60)

      second_order = Order.create!(delivery_address: 'Rua das Palmeiras, 13', delivery_city: 'Rio de Janeiro', delivery_state: 'RJ', 
                                   delivery_postal_code: '28200000', recipient: 'Denise Silva', recipient_cpf: '00000000000',
                                   recipient_email: 'denise@email.com', recipient_phone_number: '00000000000', 
                                   pick_up_address: 'Estrada do Porto, 70', pick_up_city: 'São Paulo', pick_up_state: 'SP', 
                                   pick_up_postal_code: '30000000', sku: '11100000000000000000', height: 50, width: 30, length: 130, 
                                   weight: 400, distance: 60)    

      # Act

      # Assert
      expect(second_order.tracking_code).not_to eq first_order.tracking_code
    end
  end

  describe '#origin_city_and_state' do
    it 'exibe o nome da cidade e estado de origem' do
      # Arrange
      order = Order.new(pick_up_city: 'São Paulo', pick_up_state: 'SP')

      # Act

      # Assert
      expect(order.origin_city_and_state).to eq 'São Paulo - SP'
    end
  end

  describe '#destination_city_and_state' do
    it 'exibe o nome da cidade e estado de destino' do
      # Arrange
      order = Order.new(delivery_city: 'Rio de Janeiro', delivery_state: 'RJ')

      # Act

      # Assert
      expect(order.destination_city_and_state).to eq 'Rio de Janeiro - RJ'
    end
  end

  describe '#valid?' do
    context 'presence' do
      it 'delivery_address é obrigatório' do
        # Arrange
        order = Order.new(delivery_address: '')

        # Act
        order.valid?

        # Assert
        expect(order.errors[:delivery_address]).to include('não pode ficar em branco')
      end

      it 'delivery_city é obrigatório' do
        # Arrange
        order = Order.new(delivery_city: '')

        # Act
        order.valid?

        # Assert
        expect(order.errors[:delivery_city]).to include('não pode ficar em branco')
      end

      it 'delivery_state é obrigatório' do
        # Arrange
        order = Order.new(delivery_state: '')

        # Act
        order.valid?

        # Assert
        expect(order.errors[:delivery_state]).to include('não pode ficar em branco')
      end

      it 'delivery_postal_code é obrigatório' do
        # Arrange
        order = Order.new(delivery_postal_code: '')

        # Act
        order.valid?

        # Assert
        expect(order.errors[:delivery_postal_code]).to include('não pode ficar em branco')
      end

      it 'recipient é obrigatório' do
        # Arrange
        order = Order.new(recipient: '')

        # Act
        order.valid?

        # Assert
        expect(order.errors[:recipient]).to include('não pode ficar em branco')
      end

      it 'recipient_cpf é obrigatório' do
        # Arrange
        order = Order.new(recipient_cpf: '')

        # Act
        order.valid?

        # Assert
        expect(order.errors[:recipient_cpf]).to include('não pode ficar em branco')
      end

      it 'recipient_email é obrigatório' do
        # Arrange
        order = Order.new(recipient_email: '')

        # Act
        order.valid?

        # Assert
        expect(order.errors[:recipient_email]).to include('não pode ficar em branco')
      end

      it 'recipient_phone_number é obrigatório' do
        # Arrange
        order = Order.new(recipient_phone_number: '')

        # Act
        order.valid?

        # Assert
        expect(order.errors[:recipient_phone_number]).to include('não pode ficar em branco')
      end

      it 'pick_up_address é obrigatório' do
        # Arrange
        order = Order.new(pick_up_address: '')

        # Act
        order.valid?

        # Assert
        expect(order.errors[:pick_up_address]).to include('não pode ficar em branco')
      end

      it 'pick_up_city é obrigatório' do
        # Arrange
        order = Order.new(pick_up_city: '')

        # Act
        order.valid?

        # Assert
        expect(order.errors[:pick_up_city]).to include('não pode ficar em branco')
      end

      it 'pick_up_state é obrigatório' do
        # Arrange
        order = Order.new(pick_up_state: '')

        # Act
        order.valid?

        # Assert
        expect(order.errors[:pick_up_state]).to include('não pode ficar em branco')
      end

      it 'pick_up_postal_code é obrigatório' do
        # Arrange
        order = Order.new(pick_up_postal_code: '')

        # Act
        order.valid?

        # Assert
        expect(order.errors[:pick_up_postal_code]).to include('não pode ficar em branco')
      end

      it 'sku é obrigatório' do
        # Arrange
        order = Order.new(sku: '')

        # Act
        order.valid?

        # Assert
        expect(order.errors[:sku]).to include('não pode ficar em branco')
      end

      it 'height é obrigatório' do
        # Arrange
        order = Order.new(height: '')

        # Act
        order.valid?

        # Assert
        expect(order.errors[:height]).to include('não pode ficar em branco')
      end

      it 'width é obrigatório' do
        # Arrange
        order = Order.new(width: '')

        # Act
        order.valid?

        # Assert
        expect(order.errors[:width]).to include('não pode ficar em branco')
      end

      it 'length é obrigatório' do
        # Arrange
        order = Order.new(length: '')

        # Act
        order.valid?

        # Assert
        expect(order.errors[:length]).to include('não pode ficar em branco')
      end

      it 'weight é obrigatório' do
        # Arrange
        order = Order.new(weight: '')

        # Act
        order.valid?

        # Assert
        expect(order.errors[:weight]).to include('não pode ficar em branco')
      end

      it 'distance é obrigatório' do
        # Arrange
        order = Order.new(distance: '')

        # Act
        order.valid?

        # Assert
        expect(order.errors[:distance]).to include('não pode ficar em branco')
      end
    end
  end
end
