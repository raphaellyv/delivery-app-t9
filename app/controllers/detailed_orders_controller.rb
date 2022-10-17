class DetailedOrdersController < ApplicationController
  
  def new
    @order = Order.find(params[:order_id])
    @detailed_order = DetailedOrder.new

    if @order.pending?
      @quotations = @order.generate_quotations
      @shipping_options = @order.search_possible_shipping_options
    end
  end

  def create
    @order = Order.find(params[:order_id])
    detailed_order_params = params.require(:detailed_order).permit(:shipping_option_id)
    @detailed_order = DetailedOrder.new(detailed_order_params)

    @detailed_order.order = @order
    @detailed_order.select_vehicle

    @detailed_order.set_total_price_and_estimated_delivery_date
                               
    if @detailed_order.save
      @order.en_route!
      @detailed_order.vehicle.en_route!

      redirect_to @order, notice: t(:select_shipping_option_success)    
    else
      redirect_to new_order_detailed_order_url(@order.id), alert: t(:no_vehicles_available_for_shipping_option)
    end    
  end
end