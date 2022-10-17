require 'rails_helper'

RSpec.describe ShippingOption, type: :model do
  describe '#valid?' do
    context 'presence' do
      it 'taxa fixa de entrega é obrigatório' do
        # Arrange
        so = ShippingOption.new(delivery_fee: '')

        # Act
        so.valid?

        # Assert
        expect(so.errors.include? :delivery_fee).to be true
      end

      it 'distância máxima é obrigatório' do
        # Arrange
        so = ShippingOption.new(max_distance: '')

        # Act
        so.valid?

        # Assert
        expect(so.errors.include? :max_distance).to be true
      end

      it 'peso máximo é obrigatório' do
        # Arrange
        so = ShippingOption.new(max_weight: '')

        # Act
        so.valid?

        # Assert
        expect(so.errors.include? :max_weight).to be true
      end

      it 'distância mínima é obrigatória' do
        # Arrange
        so = ShippingOption.new(min_distance: '')

        # Act
        so.valid?

        # Assert
        expect(so.errors.include? :min_distance).to be true
      end

      it 'peso mínimo é obrigatório' do
        # Arrange
        so = ShippingOption.new(min_weight: '')

        # Act
        so.valid?

        # Assert
        expect(so.errors.include? :min_weight).to be true
      end

      it 'nome é obrigatório' do
        # Arrange
        so = ShippingOption.new(name: '')

        # Act
        so.valid?

        # Assert
        expect(so.errors.include? :name).to be true
      end
    end

    context 'uniqueness' do
      it 'nome deve ser único' do
        # Arrange
        ShippingOption.create!(name: 'Entrega Expressa', min_distance: 50 , max_distance: 600, min_weight: 1000, max_weight: 50000, 
                               delivery_fee: 5.50)
                          
        so = ShippingOption.new(name: 'Entrega Expressa')

        # Act
        so.valid?

        # Assert
        expect(so.errors.include? :name).to be true
      end
    end

    context 'numericality' do
      it 'taxa fixa de entrega deve ser maior que 0' do
        # Arrange
        so = ShippingOption.new(delivery_fee: 1)

        # Act
        so.valid?

        # Assert
        expect(so.errors.include? :delivery_fee).to be false
      end

      it 'taxa fixa de entrega não deve ser igual a 0' do
        # Arrange
        so = ShippingOption.new(delivery_fee: 0)

        # Act
        so.valid?

        # Assert
        expect(so.errors.include? :delivery_fee).to be true
      end

      it 'taxa fixa de entrega não deve ser menor que 0' do
        # Arrange
        so = ShippingOption.new(delivery_fee: -1)

        # Act
        so.valid?

        # Assert
        expect(so.errors.include? :delivery_fee).to be true
      end

      it 'distância mínima pode ser maior que 0' do
        # Arrange
        so = ShippingOption.new(min_distance: 1)

        # Act
        so.valid?

        # Assert
        expect(so.errors.include? :min_distance).to be false
      end

      it 'distância mínima não deve ser igual a 0' do
        # Arrange
        so = ShippingOption.new(min_distance: 0)

        # Act
        so.valid?

        # Assert
        expect(so.errors.include? :min_distance).to be true
      end

      it 'distância mínima não deve ser menor que 0' do
        # Arrange
        so = ShippingOption.new(min_distance: -1)

        # Act
        so.valid?

        # Assert
        expect(so.errors.include? :min_distance).to be true
      end

      it 'peso mínimo deve ser maior que 0' do
        # Arrange
        so = ShippingOption.new(min_weight: 1)

        # Act
        so.valid?

        # Assert
        expect(so.errors.include? :min_weight).to be false
      end

      it 'peso mínimo não deve ser igual a 0' do
        # Arrange
        so = ShippingOption.new(min_weight: 0)

        # Act
        so.valid?

        # Assert
        expect(so.errors.include? :min_weight).to be true
      end

      it 'peso mínimo não deve ser menor que 0' do
        # Arrange
        so = ShippingOption.new(min_weight: -1)

        # Act
        so.valid?

        # Assert
        expect(so.errors.include? :min_weight).to be true
      end
    end

    context 'comparison' do
      it 'distância máxima deve ser maior que a distância mínima' do
        # Arrange
        so = ShippingOption.new(min_distance: 1, max_distance: 2)

        # Act
        so.valid?

        # Assert
        expect(so.errors.include? :max_distance).to be false
      end

      it 'distância máxima não deve ser igual à distância mínima' do
        # Arrange
        so = ShippingOption.new(min_distance: 1, max_distance: 1)

        # Act
        so.valid?

        # Assert
        expect(so.errors.include? :max_distance).to be true
      end

      it 'distância máxima não deve ser menor que a distância mínima' do
        # Arrange
        so = ShippingOption.new(min_distance: 2, max_distance: 1)

        # Act
        so.valid?

        # Assert
        expect(so.errors.include? :max_distance).to be true
      end

      it 'peso máximo deve ser maior que o peso mínimo' do
        # Arrange
        so = ShippingOption.new(min_weight: 1, max_weight: 2)

        # Act
        so.valid?

        # Assert
        expect(so.errors.include? :max_weight).to be false
      end

      it 'peso máximo não deve ser igual ao peso mínimo' do
        # Arrange
        so = ShippingOption.new(min_weight: 1, max_weight: 1)

        # Act
        so.valid?

        # Assert
        expect(so.errors.include? :max_weight).to be true
      end

      it 'peso máximo não deve ser menor que o peso mínimo' do
        # Arrange
        so = ShippingOption.new(min_weight: 2, max_weight: 1)

        # Act
        so.valid?

        # Assert
        expect(so.errors.include? :max_weight).to be true
      end
    end
  end

  describe '#enabled?' do
    it 'a modalidade de transporte é criada como ativa' do
      # Arrange
      so = ShippingOption.create!(name: 'Entrega Básica', min_distance: 30 , max_distance: 800, min_weight: 1500, max_weight: 40000, 
                                  delivery_fee: 3.00)


      # Act

      # Assert
      expect(so.enabled?).to be true
    end
  end

  describe '#generate_quotation_for' do
    it 'retorna uma hash com o orçamento e prazo da modalidade de transporte para uma ordem de serviço' do
      # Arrange
      shipping_option = ShippingOption.create!(name: 'Entrega Expressa', min_distance: 50 , max_distance: 600, min_weight: 1_000, 
                                               max_weight: 50_000, delivery_fee: 5.50, status: :enabled)
      
      price_a = Price.create!(min_weight: 1_000, max_weight: 2_000, price_per_km: 3.00, shipping_option: shipping_option)
      price_aa = Price.create!(min_weight: 2_001, max_weight: 4_000, price_per_km: 1.00, shipping_option: shipping_option)
      distance_fee_a = DistanceFee.create!(min_distance: 50, max_distance: 200, fee: 2.00, shipping_option: shipping_option)
      distance_fee_aa = DistanceFee.create!(min_distance: 201, max_distance: 350, fee: 2.50, shipping_option: shipping_option)
      deadline_a = Deadline.create!(min_distance: 60, max_distance: 200, deadline: 30, shipping_option: shipping_option)
      deadline_aa = Deadline.create!(min_distance: 201, max_distance: 400, deadline: 48, shipping_option: shipping_option)

      order = Order.create!(delivery_address: 'Rua das Palmeiras, 13', delivery_city: 'Rio de Janeiro', delivery_state: 'RJ', 
                            delivery_postal_code: '28200000', recipient: 'Denise Silva', recipient_cpf: '00000000000',
                            recipient_email: 'denise@email.com', recipient_phone_number: '2297523040', 
                            pick_up_address: 'Estrada do Porto, 70', pick_up_city: 'São Paulo', pick_up_state: 'SP', 
                            pick_up_postal_code: '30000000', sku: 'TV32P-SAMSUNG-XPTO90', height: 60, width: 40, length: 100, 
                            weight: 3_000, distance: 300, status: :pending)

      # Act

      # Assert
      expect(shipping_option.generate_quotation_for(order)).to include(shipping_option: shipping_option, order: order, 
                                                                       deadline: 48, price: 308.00)
    end
  end
end
