# Usuário regular
User.create!(name: 'Maria', email: 'maria@sistemadefrete.com.br', password: 'password')

# Usuário administrador
User.create!(name: 'Pessoa', email: 'pessoa@sistemadefrete.com.br', password: 'password', role: :admin)

# Ordens de serviço pendente criadas pelo administrador
Order.create!(delivery_address: 'Rua das Palmeiras, 13', delivery_city: 'Rio de Janeiro', delivery_state: 'RJ', 
              delivery_postal_code: '28200000', recipient: 'Denise Silva', recipient_cpf: '00000000000',
              recipient_email: 'denise@email.com', recipient_phone_number: '00000000000', 
              pick_up_address: 'Estrada do Porto, 70', pick_up_city: 'São Paulo', pick_up_state: 'SP', 
              pick_up_postal_code: '30000000', sku: '00000000000000000000', height: 60, width: 40, length: 100, 
              weight: 300, distance: 300)
              
Order.create!(delivery_address: 'Rua das Oliveiras, 15', delivery_city: 'São Gonçalo', delivery_state: 'RJ', 
              delivery_postal_code: '28200000', recipient: 'Marta Silva', recipient_cpf: '00000000000',
              recipient_email: 'martae@email.com', recipient_phone_number: '00000000000', 
              pick_up_address: 'Estrada do Porto, 70', pick_up_city: 'Santo André', pick_up_state: 'SP', 
              pick_up_postal_code: '30000000', sku: 'TV32P-SAMSUNG-XPTO90', height: 60, width: 40, length: 100, 
              weight: 300, distance: 230)