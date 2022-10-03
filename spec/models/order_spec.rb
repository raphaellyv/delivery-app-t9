require 'rails_helper'

RSpec.describe Order, type: :model do
  describe '#destination_city_and_state' do
    it 'exibe o nome da cidade e estado de destino' do
      # Arrange
      order = Order.new(delivery_city: 'Rio de Janeiro', delivery_state: 'RJ')

      # Act

      # Assert
      expect(order.destination_city_and_state).to eq 'Rio de Janeiro - RJ'
    end
  end

  describe '#dimensions' do
    it 'exibe comprimento, largura e altura do produto' do
      # Arrange
      order = Order.new(length: 100, width: 70, height: 50)

      # Act

      # Assert
      expect(order.dimensions).to eq '100 cm x 70 cm x 50 cm'
    end
  end

  describe '#formatted_delivery_postal_code' do
    it 'exibe o CEP de entrega formatado' do
      # Arrange
      order = Order.new(delivery_postal_code: '12345678')

      # Act

      # Assert
      expect(order.formatted_delivery_postal_code).to eq '12.345-678'
    end
  end

  describe '#formatted_pick_up_postal_code' do
    it 'exibe o CEP de retirada formatado' do
      # Arrange
      order = Order.new(pick_up_postal_code: '12345678')

      # Act

      # Assert
      expect(order.formatted_pick_up_postal_code).to eq '12.345-678'
    end
  end
  
  describe '#formatted_cpf' do
    it 'exibe o CPF do destinatário formatado' do
      # Arrange
      order = Order.new(recipient_cpf: '12345678901')

      # Act

      # Assert
      expect(order.formatted_cpf).to eq '123.456.789-01'
    end
  end

  describe '#formatted_phone_number' do
    it 'exibe o telefone de 11 dígitos do destinatário formatado' do
      # Arrange
      order = Order.new(recipient_phone_number: '12345678901')

      # Act

      # Assert
      expect(order.formatted_phone_number).to eq '(12) 34567-8901'
    end

    it 'exibe o telefone de 10 dígitos do destinatário formatado' do
      # Arrange
      order = Order.new(recipient_phone_number: '1234567890')

      # Act

      # Assert
      expect(order.formatted_phone_number).to eq '(12) 3456-7890'
    end
  end

  describe '#full_delivery_address' do
    it 'exibe o endereço, cidade e estado de entrega' do
      # Arrange
      order = Order.new(delivery_address: 'Estrada do Porto, 70', delivery_city: 'Santo André', delivery_state: 'SP')

      # Act

      # Assert
      expect(order.full_delivery_address).to eq 'Estrada do Porto, 70 - Santo André - SP'
    end
  end

  describe '#full_pick_up_address' do
    it 'exibe o endereço, cidade e estado de retirada' do
      # Arrange
      order = Order.new(pick_up_address: 'Estrada do Porto, 70', pick_up_city: 'Santo André', pick_up_state: 'SP')

      # Act

      # Assert
      expect(order.full_pick_up_address).to eq 'Estrada do Porto, 70 - Santo André - SP'
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

  describe '#valid?' do
    context 'format' do
      it 'delivery_postal_code deve conter somente números' do
        # Arrange
        order = Order.new(delivery_postal_code: '5HBf9CIu')

        # Act
        order.valid?

        # Assert
        expect(order.errors.include? :delivery_postal_code).to be true
      end

      it 'pick_up_postal_code deve conter somente números' do
        # Arrange
        order = Order.new(pick_up_postal_code: '5HBf9CIu')

        # Act
        order.valid?

        # Assert
        expect(order.errors.include? :pick_up_postal_code).to be true
      end

      it 'recipient_cpf deve conter somente números' do
        # Arrange
        order = Order.new(recipient_cpf: '5HBf9CIufu5')

        # Act
        order.valid?

        # Assert
        expect(order.errors.include? :recipient_cpf).to be true
      end

      it 'recipient_email deve ser um e-mail' do
        # Arrange
        order = Order.new(recipient_email: 'denise.com')

        # Act
        order.valid?

        # Assert
        expect(order.errors.include? :recipient_email).to be true
      end

      it 'recipient_phone_number deve conter somente números' do
        # Arrange
        order = Order.new(recipient_phone_number: '5HBf9CIuf')

        # Act
        order.valid?

        # Assert
        expect(order.errors.include? :recipient_phone_number).to be true
      end
    end
    
    context 'length' do
      it 'delivery_postal_code deve ter 8 dígitos' do
         # Arrange
         order = Order.new(delivery_postal_code: '12345678')

         # Act
         order.valid?
 
         # Assert
         expect(order.errors.include? :delivery_postal_code).to be false
      end

      it 'delivery_postal_code não deve ter mais que 8 dígitos' do
        # Arrange
        order = Order.new(delivery_postal_code: '123456789')

        # Act
        order.valid?

        # Assert
        expect(order.errors.include? :delivery_postal_code).to be true
      end

      it 'delivery_postal_code não deve ter menos que 8 dígitos' do
        # Arrange
        order = Order.new(delivery_postal_code: '1234567')

        # Act
        order.valid?

        # Assert
        expect(order.errors.include? :delivery_postal_code).to be true
     end

      it 'pick_up_postal_code deve ter 8 dígitos' do
        # Arrange
        order = Order.new(pick_up_postal_code: '12345678')

        # Act
        order.valid?

        # Assert
        expect(order.errors.include? :pick_up_postal_code).to be false
     end

      it 'pick_up_postal_code não deve ter mais que 8 dígitos' do
        # Arrange
        order = Order.new(pick_up_postal_code: '123456789')

        # Act
        order.valid?

        # Assert
        expect(order.errors.include? :pick_up_postal_code).to be true
      end

      it 'pick_up_postal_code não deve ter menos que 8 dígitos' do
        # Arrange
        order = Order.new(pick_up_postal_code: '1234567')

        # Act
        order.valid?

        # Assert
        expect(order.errors.include? :pick_up_postal_code).to be true
      end

      it 'recipient_cpf deve ter 11 dígitos' do
        # Arrange
        order = Order.new(recipient_cpf: '12345678901')

        # Act
        order.valid?

        # Assert
        expect(order.errors.include? :recipient_cpf).to be false
      end

      it 'recipient_cpf não deve ter mais que 11 dígitos' do
        # Arrange
        order = Order.new(recipient_cpf: '123456789012')

        # Act
        order.valid?

        # Assert
        expect(order.errors.include? :recipient_cpf).to be true
      end

      it 'recipient_cpf não deve ter menos que 11 dígitos' do
        # Arrange
        order = Order.new(recipient_cpf: '1234567890')

        # Act
        order.valid?

        # Assert
        expect(order.errors.include? :recipient_cpf).to be true
      end

      it 'recipient_phone_number não deve ter mais que 11 dígitos' do
        # Arrange
        order = Order.new(recipient_phone_number: '123456789012')

        # Act
        order.valid?

        # Assert
        expect(order.errors.include? :recipient_phone_number).to be true
      end

      it 'recipient_phone_number não deve ter menos que 10 dígitos' do
        # Arrange
        order = Order.new(recipient_phone_number: '123456789')

        # Act
        order.valid?

        # Assert
        expect(order.errors.include? :recipient_phone_number).to be true
      end

      it 'recipient_phone_number pode ter 10 dígitos' do
        # Arrange
        order = Order.new(recipient_phone_number: '1234567890')

        # Act
        order.valid?

        # Assert
        expect(order.errors.include? :recipient_phone_number).to be false
      end

      it 'recipient_phone_number pode ter 11 dígitos' do
        # Arrange
        order = Order.new(recipient_phone_number: '12345678901')

        # Act
        order.valid?

        # Assert
        expect(order.errors.include? :recipient_phone_number).to be false
      end

      it 'SKU deve ter 20 dígitos' do
        # Arrange
        order = Order.new(sku: 'TV32P-SAMSUNG-XPTO90')

        # Act
        order.valid?

        # Assert
        expect(order.errors.include? :sku).to be false
      end

      it 'SKU não deve ter mais que 20 dígitos' do
        # Arrange
        order = Order.new(sku: 'TV32P-SAMSUNG-XPTO901')

        # Act
        order.valid?

        # Assert
        expect(order.errors.include? :sku).to be true
      end

      it 'SKU não deve ter menos que 20 dígitos' do
        # Arrange
        order = Order.new(sku: 'TV32P-SAMSUNG-XPTO9')

        # Act
        order.valid?

        # Assert
        expect(order.errors.include? :sku).to be true
      end
    end

    context 'numericality' do
      it 'distance deve ser maior que 0' do
        # Arrange
        order = Order.new(distance: 1)

        # Act
        order.valid?

        # Assert
        expect(order.errors.include? :distance).to be false
      end

      it 'distance não deve ser igual a 0' do
        # Arrange
        order = Order.new(distance: 0)

        # Act
        order.valid?

        # Assert
        expect(order.errors.include? :distance).to be true
      end

      it 'distance não deve ser menor que 0' do
        # Arrange
        order = Order.new(distance: -1)

        # Act
        order.valid?

        # Assert
        expect(order.errors.include? :distance).to be true
      end

      it 'height deve ser maior que 0' do
        # Arrange
        order = Order.new(height: 1)

        # Act
        order.valid?

        # Assert
        expect(order.errors.include? :height).to be false
      end

      it 'height não deve ser igual a 0' do
        # Arrange
        order = Order.new(height: 0)

        # Act
        order.valid?

        # Assert
        expect(order.errors.include? :height).to be true
      end

      it 'height não deve ser menor que 0' do
        # Arrange
        order = Order.new(height: -1)

        # Act
        order.valid?

        # Assert
        expect(order.errors.include? :height).to be true
      end

      it 'length deve ser maior que 0' do
        # Arrange
        order = Order.new(length: 1)

        # Act
        order.valid?

        # Assert
        expect(order.errors.include? :length).to be false
      end

      it 'length não deve ser igual a 0' do
        # Arrange
        order = Order.new(length: 0)

        # Act
        order.valid?

        # Assert
        expect(order.errors.include? :length).to be true
      end

      it 'length não deve ser menor que 0' do
        # Arrange
        order = Order.new(length: -1)

        # Act
        order.valid?

        # Assert
        expect(order.errors.include? :length).to be true
      end

      it 'width deve ser maior que 0' do
        # Arrange
        order = Order.new(width: 1)

        # Act
        order.valid?

        # Assert
        expect(order.errors.include? :width).to be false
      end

      it 'weight deve ser maior que 0' do
        # Arrange
        order = Order.new(weight: 1)

        # Act
        order.valid?

        # Assert
        expect(order.errors.include? :weight).to be false
      end

      it 'weight não deve ser igual a 0' do
        # Arrange
        order = Order.new(weight: 0)

        # Act
        order.valid?

        # Assert
        expect(order.errors.include? :weight).to be true
      end

      it 'weight não deve ser menor que 0' do
        # Arrange
        order = Order.new(weight: -1)

        # Act
        order.valid?

        # Assert
        expect(order.errors.include? :weight).to be true
      end

      it 'width deve ser maior que 0' do
        # Arrange
        order = Order.new(width: 1)

        # Act
        order.valid?

        # Assert
        expect(order.errors.include? :width).to be false
      end

      it 'width não deve ser igual a 0' do
        # Arrange
        order = Order.new(width: 0)

        # Act
        order.valid?

        # Assert
        expect(order.errors.include? :width).to be true
      end
      
      it 'width não deve ser menor que 0' do
        # Arrange
        order = Order.new(width: -1)

        # Act
        order.valid?

        # Assert
        expect(order.errors.include? :width).to be true
      end
    end
    
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
end
