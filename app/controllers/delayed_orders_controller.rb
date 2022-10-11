class DelayedOrdersController < ApplicationController
  before_action :authenticate_user!

  def new
    @order = Order.find(params[:order_id])
    @delayed_order = DelayedOrder.new
  end

  def create
    @order = Order.find(params[:order_id])

    delayed_order = DelayedOrder.new(params.require(:delayed_order).permit(:cause_of_delay))
    delayed_order.order = @order
    
    if delayed_order.save
      redirect_to @order, notice: t(:add_cause_of_delay_success)
    end
  end
end