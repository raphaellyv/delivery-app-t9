class ShippingOptionsController < ApplicationController
  before_action :authenticate_user!

  def index
    @shipping_options = ShippingOption.all.order(:name)
    @shipping_option = ShippingOption.new
  end

  def create
    so_params = params.require(:shipping_option).permit(:name, :min_distance, :max_distance, :min_weight, 
                                                        :max_weight, :delivery_fee)
    @shipping_option = ShippingOption.new(so_params)

    if @shipping_option.save
      redirect_to shipping_options_url, notice: t(:so_registration_success)

    else
      @shipping_options = ShippingOption.all.order(:name)
      
      flash.now[:alert] = t(:so_registration_error)
      render 'index'
    end
  end

  def enable
    @shipping_option = ShippingOption.find(params[:id])
    @shipping_option.enabled!
    redirect_to shipping_options_path, notice: t(:enable_so_success)
  end

  private

  def check_admin
    if current_user.regular?
      redirect_to root_path, alert: t(:admin_restricted_area)
    end
  end
end