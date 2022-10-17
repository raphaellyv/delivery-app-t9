class DistanceFeesController < ApplicationController
  before_action :check_admin, only: [:new, :create, :edit, :update]
  
  def new
    @shipping_option = ShippingOption.find(params[:shipping_option_id])
    @distance_fee = DistanceFee.new(shipping_option: @shipping_option)
    @distance_fees = @shipping_option.distance_fees.order(:min_distance)
  end

  def create
    @shipping_option = ShippingOption.find(params[:shipping_option_id])
    @distance_fee = DistanceFee.new( distance_fee_params)
    @distance_fee.shipping_option = @shipping_option

    if @distance_fee.save
      redirect_to new_shipping_option_distance_fee_url(@shipping_option.id), notice: t(:distance_fee_registration_success)
    else
      @distance_fees = @shipping_option.distance_fees.order(:min_distance) 
      flash.now[:alert] = t(:distance_fee_registration_error)
      render 'new'
    end
  end

  def edit
    @shipping_option = ShippingOption.find(params[:shipping_option_id])
    @distance_fee = DistanceFee.find(params[:id])
    @distance_fees = @shipping_option.distance_fees.order(:min_distance)
  end

  def update
    @shipping_option = ShippingOption.find(params[:shipping_option_id])
    @distance_fee = DistanceFee.find(params[:id])

    if @distance_fee.update(distance_fee_params)
      redirect_to @shipping_option, notice: t(:distance_fee_update_success)
    else
      @distance_fees = @shipping_option.distance_fees.order(:min_distance)  
      flash.now[:alert] = t(:distance_fee_update_error)
      render 'edit'
    end
  end

  private

  def distance_fee_params
    params.require(:distance_fee).permit(:min_distance, :max_distance, :fee)
  end
end