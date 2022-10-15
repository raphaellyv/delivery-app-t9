class DeadlinesController < ApplicationController
  before_action :check_admin, only: [:new]

  def index
    @deadlines = Deadline.all.order(:min_distance)
  end

  def new
    @shipping_option = ShippingOption.find(params[:shipping_option_id])
    @deadline = Deadline.new(shipping_option: @shipping_option)
    @deadlines = Deadline.all.order(:min_distance)
  end

  def create
    @shipping_option = ShippingOption.find(params[:shipping_option_id])
    @deadline = Deadline.new(deadline_params)
    @deadline.shipping_option = @shipping_option

    if @deadline.save
      redirect_to new_shipping_option_deadline_path(@shipping_option.id), notice: t(:deadline_registration_success)
    else
      @deadlines = @shipping_option.deadlines.order(:min_distance)  
      flash.now[:alert] = t(:deadline_registration_error)
      render 'new'
    end
  end

  private

  def deadline_params
    params.require(:deadline).permit(:min_distance, :max_distance, :deadline)
  end
end