class OrdersController < ApplicationController
  before_action :authenticate_user!, except: ['search']
  before_action :check_admin, only: [:new, :create]
  
  def index
    @orders = Order.all.order(id: :desc)
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

    if @order.pending?
      prices = Price.where(["min_weight <= ? and max_weight >= ?", @order.weight, @order.weight])
      deadlines = Deadline.where(["min_distance <= ? and max_distance >= ?", @order.distance, @order.distance])

      @quotations = []

      deadlines.each do |deadline|
        prices.each do |price|
          if (price.shipping_option == deadline.shipping_option) && (price.shipping_option.enabled?)
            total_amount = (price.price_per_km * @order.distance) + price.shipping_option.delivery_fee
            @quotations << {shipping_option: price.shipping_option, order: @order, deadline: deadline.deadline, price: total_amount}
          end
        end
      end
    end
  end 

  def search
    @tracking_code = params[:query]
    @order = Order.find_by(tracking_code: @tracking_code)
  end

  def deliver
    @order = Order.find(params[:id])
    
    @order.detailed_order.update(delivery_date: Time.now)


    if @order.detailed_order.delivery_date <= @order.detailed_order.estimated_delivery_date
      @order.vehicle.available!
      @order.delivered_on_time!
      redirect_to @order, notice: t(:order_delivered_on_time)

    else
      redirect_to  new_order_delayed_order_url(@order), alert: t(:order_delivered_late)
    end  
  end
end