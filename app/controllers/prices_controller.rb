class PricesController < ApplicationController
  before_action :check_admin, only: [:new, :create, :edit, :update]

  def index
    @prices = Price.all.order(:min_weight)
  end

  def new
    @shipping_option = ShippingOption.find(params[:shipping_option_id])
    @price = Price.new(shipping_option: @shipping_option)
    @prices = @shipping_option.prices.order(:min_weight)
  end

  def create
    @shipping_option = ShippingOption.find(params[:shipping_option_id])
    @price = Price.new(price_params)
    @price.shipping_option = @shipping_option

    if @price.save
      redirect_to new_shipping_option_price_url(@shipping_option.id), notice: t(:price_registration_success)
    else
      @prices = @shipping_option.prices.order(:min_weight)

      flash.now[:alert] = t(:price_registration_error)
      render 'new' 
    end
  end

  def edit
    @shipping_option = ShippingOption.find(params[:shipping_option_id])
    @prices = @shipping_option.prices.order(:min_weight)
    @price = Price.find(params[:id])
  end

  def update
    @shipping_option = ShippingOption.find(params[:shipping_option_id])
    @price = Price.find(params[:id])

    if @price.update(price_params)
      redirect_to @shipping_option, notice: t(:price_update_success)
    else
      @prices = @shipping_option.prices.order(:min_weight)  
      flash.now[:alert] = t(:price_update_error)
      render 'edit'
    end
  end

  private

  def price_params
    params.require(:price).permit(:min_weight, :max_weight, :price_per_km)
  end
end