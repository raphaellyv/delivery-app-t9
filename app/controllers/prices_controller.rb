class PricesController < ApplicationController
  before_action :authenticate_user!

  def index
    @prices = Price.all.order(:min_weight)
  end
end