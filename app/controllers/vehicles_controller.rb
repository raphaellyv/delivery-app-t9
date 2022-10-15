class VehiclesController < ApplicationController
  before_action :check_admin, only: [:create, :edit, :update, :sent_to_maintenance, :make_available]
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

  def show
    if @vehicle.en_route?
      @order = @vehicle.orders.find_by(status: :en_route)
    end
  end

  def edit
    @shipping_options = ShippingOption.enabled.order(:name)
  end

  def update
    if @vehicle.update(vehicle_params)
      redirect_to @vehicle, notice: t(:vehicle_update_success)
    else
      @shipping_options = ShippingOption.enabled.order(:name)
        
      flash.now[:alert] = t(:vehicle_update_error)
      render 'edit'
    end
  end

  def sent_to_maintenance
    @vehicle.maintenance!
    redirect_to @vehicle, notice: t(:status_change_success)
  end

  def make_available
    @vehicle.available!
    redirect_to @vehicle, notice: t(:status_change_success) 
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