class DelayedOrdersController < ApplicationController

  def new
    @order = Order.find(params[:order_id])
    @delayed_order = DelayedOrder.new
  end

  def create
    @order = Order.find(params[:order_id])

    delayed_order = DelayedOrder.new(params.require(:delayed_order).permit(:cause_of_delay))
    delayed_order.order = @order
    
    if delayed_order.save
      @order.vehicle.available!
      @order.delivered_late!
      redirect_to @order, notice: t(:add_cause_of_delay_success)
    else
      redirect_to new_order_delayed_order_url(@order), alert: t(:conclude_delayed_order_error)
    end
  end
end