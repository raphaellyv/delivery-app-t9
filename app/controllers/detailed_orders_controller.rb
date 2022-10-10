class DetailedOrdersController < ApplicationController
  before_action :authenticate_user!
  
  def new
    @order = Order.find(params[:order_id])
    @detailed_order = DetailedOrder.new

    if @order.pending?
      generate_quotation
    end
  end

  def create
    @order = Order.find(params[:order_id])
    detailed_order_params = params.require(:detailed_order).permit(:shipping_option_id)
    generate_quotation

    @detailed_order = DetailedOrder.new(detailed_order_params)
    @detailed_order.order = @order

    quotation = @quotations.find{ |quotation| quotation[:shipping_option] == @detailed_order.shipping_option }
    @detailed_order.total_price = quotation[:price]
    @detailed_order.estimated_delivery_date = Time.now + quotation[:deadline].hours
    @detailed_order.vehicle = @detailed_order.shipping_option.vehicles.available.order(:updated_at)[0]

    if @detailed_order.save
      @order.en_route!
      @detailed_order.vehicle.en_route!

      redirect_to @order, notice: t(:select_shipping_option_success)    
    else
      redirect_to new_order_detailed_order_path(@order.id), alert: t(:no_vehicles_available_for_shipping_option)
    end    
  end
end

private

def generate_quotation
  prices = Price.where(["min_weight <= ? and max_weight >= ?", @order.weight, @order.weight])
  deadlines = Deadline.where(["min_distance <= ? and max_distance >= ?", @order.distance, @order.distance])

  @quotations = []
  @shipping_options = []

  deadlines.each do |deadline|
    prices.each do |price|
      if price.shipping_option == deadline.shipping_option
        total_amount = (price.price_per_km * @order.distance) + price.shipping_option.delivery_fee
            
        @quotations << {shipping_option: price.shipping_option, order: @order, deadline: deadline.deadline, price: total_amount}
        @shipping_options << price.shipping_option
      end
    end
  end
end