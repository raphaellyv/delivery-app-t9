class OrdersController < ApplicationController
  before_action :authenticate_user!, except: ['search']
  before_action :check_admin, only: [:new]
  
  def index
    @orders = Order.all
  end

  def new
    @order = Order.new
  end

  def create
    order_params = params.require(:order).permit(:delivery_address, :delivery_city, :delivery_state, :delivery_postal_code, 
                                                  :recipient, :recipient_cpf, :recipient_email, :recipient_phone_number, 
                                                  :pick_up_address, :pick_up_city, :pick_up_state, :pick_up_postal_code, 
                                                  :sku, :height, :width, :length, :weight, :distance)
    @order = Order.new(order_params)

    if @order.save
      redirect_to @order, notice: t(:order_registration_success)
    else
      flash.now[:alert] = t(:order_registration_error)

      render 'new'
    end
  end

  def show
    @order = Order.find(params[:id])
  end 

  def search
    @tracking_code = params[:query]
    @order = Order.find_by(tracking_code: @tracking_code)
  end

  private

  def check_admin
    if current_user.regular?
      redirect_to root_path, alert: 'Área restrita para administradores'
    end
  end
end