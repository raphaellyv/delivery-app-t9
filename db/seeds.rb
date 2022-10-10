# Ordens de serviço pendentes criadas pelo administrador
order_a = Order.create!(delivery_address: 'Rua das Palmeiras, 13', delivery_city: 'Rio de Janeiro', delivery_state: 'RJ', 
              delivery_postal_code: '28200000', recipient: 'Denise Silva', recipient_cpf: '00000000000',
              recipient_email: 'denise@email.com', recipient_phone_number: '00000000000', 
              pick_up_address: 'Estrada do Porto, 70', pick_up_city: 'São Paulo', pick_up_state: 'SP', 
              pick_up_postal_code: '30000000', sku: '00000000000000000000', height: 60, width: 40, length: 100, 
              weight: 300, distance: 300, status: :delivered_on_time)
  
order_b = Order.create!(delivery_address: 'Rua das Oliveiras, 15', delivery_city: 'São Gonçalo', delivery_state: 'RJ', 
              delivery_postal_code: '28200000', recipient: 'Marta Silva', recipient_cpf: '00000000000',
              recipient_email: 'martae@email.com', recipient_phone_number: '00000000000', 
              pick_up_address: 'Estrada do Porto, 70', pick_up_city: 'Santo André', pick_up_state: 'SP', 
              pick_up_postal_code: '30000000', sku: 'TV32P-SAMSUNG-XPTO90', height: 60, width: 40, length: 100, 
              weight: 2_000, distance: 230, status: :en_route)

Order.create!(delivery_address: 'Rua das Palmeiras, 13', delivery_city: 'Rio de Janeiro', delivery_state: 'RJ', 
                delivery_postal_code: '28200000', recipient: 'Denise Silva', recipient_cpf: '00000000000',
                recipient_email: 'denise@email.com', recipient_phone_number: '2297523040', 
                pick_up_address: 'Estrada do Porto, 70', pick_up_city: 'São Paulo', pick_up_state: 'SP', 
                pick_up_postal_code: '30000000', sku: 'TV32P-SAMSUNG-XPTO90', height: 60, width: 40, length: 100, 
                weight: 3_000, distance: 300, status: :pending)

# Modalidades de Transporte
so_a = ShippingOption.create!(name: 'Entrega Expressa', min_distance: 50 , max_distance: 600, min_weight: 200, max_weight: 50_000, 
                              delivery_fee: 5.50, status: :enabled)

so_b = ShippingOption.create!(name: 'Entrega Básica', min_distance: 30 , max_distance: 800, min_weight: 1_500, max_weight: 40_000, 
                              delivery_fee: 3.00, status: :enabled)

# Prazos de Entrega
Deadline.create!(min_distance: 60, max_distance: 200, deadline: 30, shipping_option: so_a)
Deadline.create!(min_distance: 201, max_distance: 400, deadline: 48, shipping_option: so_a)

Deadline.create!(min_distance: 60, max_distance: 200, deadline: 20, shipping_option: so_b)
Deadline.create!(min_distance: 201, max_distance: 400, deadline: 40, shipping_option: so_b)

#Preços por Km
Price.create!(min_weight: 300, max_weight: 2_000, price_per_km: 3.00, shipping_option: so_a)
Price.create!(min_weight: 2_001, max_weight: 4_000, price_per_km: 1.00, shipping_option: so_a)

Price.create!(min_weight: 1_500, max_weight: 2_000, price_per_km: 3.50, shipping_option: so_b)
Price.create!(min_weight: 2_001, max_weight: 4_000, price_per_km: 1.50, shipping_option: so_b)

# Veículos
vehicle_a = Vehicle.create!(shipping_option: so_a, license_plate: 'AAA0000', brand: 'Peugeot', car_model: 'Partner CS', manufacture_year: '2021',
                           max_weight: 800_000, status: :available)

Vehicle.create!(shipping_option: so_b, license_plate: 'BBB0000', brand: 'Fiat', car_model: 'Partner TX', manufacture_year: '2020',
                max_weight: 700_000, status: :maintenance)

Vehicle.create!(shipping_option: so_b, license_plate: 'BBB0003', brand: 'Fiat', car_model: 'Partner TX', manufacture_year: '2020',
                max_weight: 700_000, status: :en_route)

# Detalhes da Ordem de Serviço
DetailedOrder.create!(order: order_a, shipping_option: so_a, total_price: 905.50, 
                      estimated_delivery_date: Time.now + 48.hours, vehicle: vehicle_a)
DetailedOrder.create!(order: order_b, shipping_option: so_a, total_price: 695.50, 
                      estimated_delivery_date: Time.now + 48.hours, vehicle: vehicle_a)

# Usuário administrador
User.create!(name: 'Pessoa', email: 'pessoa@sistemadefrete.com.br', password: 'password', role: :admin)

# Usuário regular
User.create!(name: 'Maria', email: 'maria@sistemadefrete.com.br', password: 'password')