class PricesController < ApplicationController
  before_action :authenticate_user!
  before_action :check_admin, only: [:new]

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
    @price = Price.new(params.require(:price).permit(:min_weight, :max_weight, :price_per_km))
    @price.shipping_option = @shipping_option

    if @price.save
      redirect_to new_shipping_option_price_path(@shipping_option.id), notice: t(:price_registration_success)
    else
      @prices = @shipping_option.prices.order(:min_weight)

      flash.now[:alert] = t(:price_registration_error)
      render 'new' 
    end
  end
end