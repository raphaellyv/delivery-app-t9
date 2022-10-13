class VehiclesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_vehicle, only: [:show, :edit, :update, :sent_to_maintenance, :make_available]

  def index
    @vehicles = Vehicle.all.order(:status)

    if current_user.admin?
      @vehicle = Vehicle.new
      @shipping_options = ShippingOption.enabled.order(:name)
    end
  end

  def create
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

  def show; end

  def edit
    if current_user.admin?
      @shipping_options = ShippingOption.enabled.order(:name)
    else
      redirect_to root_path, alert: t(:admin_restricted_area)
    end
  end

  def update
    if current_user.admin?
      if @vehicle.update(vehicle_params)
      redirect_to @vehicle, notice: t(:vehicle_update_success)
      else
        @shipping_options = ShippingOption.enabled.order(:name)
        
        flash.now[:alert] = t(:vehicle_update_error)
        render 'edit'
      end
    else
      redirect_to root_path, alert: t(:admin_restricted_area)
    end
  end

  def sent_to_maintenance
    if current_user.admin?
      @vehicle.maintenance!
      redirect_to @vehicle, notice: t(:status_change_success)
    end    
  end

  def make_available
    if current_user.admin?
      @vehicle.available!
      redirect_to @vehicle, notice: t(:status_change_success)
    end  
  end

  def search
    @license_plate = params[:query]
    @vehicles = Vehicle.where("license_plate LIKE ?", "%#{ @license_plate }%")
  end

  private

  def vehicle_params
    vehicle_params = params.require(:vehicle).permit(:license_plate, :brand, :shipping_option_id, :car_model,
                                                     :manufacture_year, :max_weight) 
  end

  def set_vehicle
    @vehicle = Vehicle.find(params[:id])
  end
end