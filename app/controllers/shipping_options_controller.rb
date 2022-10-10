class ShippingOptionsController < ApplicationController
  before_action :authenticate_user!
  before_action :check_admin, only: [:update, :disable, :enable]
  before_action :set_shipping_option, only: [:show, :edit, :update, :enable, :disable]

  def index
    if current_user.admin?
      @shipping_options = ShippingOption.all.order(:name)

    else
      @shipping_options = ShippingOption.enabled.order(:name)
    end
    
    @shipping_option = ShippingOption.new
  end

  def create
    @shipping_option = ShippingOption.new(shipping_option_params)

    if @shipping_option.save
      redirect_to shipping_options_url, notice: t(:shipping_option_registration_success)

    else
      @shipping_options = ShippingOption.all.order(:name)
      
      flash.now[:alert] = t(:shipping_option_registration_error)
      render 'index'
    end
  end

  def show; end

  def edit
    if current_user.regular?
      redirect_to shipping_options_url
    end
  end

  def update
    if @shipping_option.update(shipping_option_params)
      redirect_to @shipping_option, notice: t(:shipping_option_update_success)

    else
      flash.now[:alert] = t(:shipping_option_update_error)
      render 'edit'
    end
  end

  def enable
    @shipping_option.enabled!
    redirect_to @shipping_option, notice: t(:enable_shipping_option_success)
  end

  def disable
    @shipping_option.disabled!
    redirect_to @shipping_option, notice: t(:disable_shipping_option_success)
  end

  private

  def check_admin
    if current_user.regular?
      redirect_to root_path, alert: t(:admin_restricted_area)
    end
  end

  def set_shipping_option
    @shipping_option = ShippingOption.find(params[:id])
  end

  def shipping_option_params
    params.require(:shipping_option).permit(:name, :min_distance, :max_distance, :min_weight, 
                                            :max_weight, :delivery_fee)
  end
end