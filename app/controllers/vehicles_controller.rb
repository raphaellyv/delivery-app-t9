class VehiclesController < ApplicationController
  before_action :authenticate_user!

  def index
    @vehicles = Vehicle.all.order(:status)

    if current_user.admin?
      @vehicle = Vehicle.new
      @shipping_options = ShippingOption.enabled.order(:name)
    end
  end

  def create
    vehicle_params = params.require(:vehicle).permit(:license_plate, :brand, :shipping_option_id, :car_model,
                                                     :manufacture_year, :max_weight) 
    @vehicle = Vehicle.new(vehicle_params)

    if @vehicle.save
      redirect_to vehicles_url, notice: t(:vehicle_registration_success)
    else
      @shipping_options = ShippingOption.enabled.order(:name)
      @vehicles = Vehicle.all.order(:status)
      
      flash.now[:alert] = t(:vehicle_registration_error)
      render 'index'
    end
  end
end