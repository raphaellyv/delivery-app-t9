class DeadlinesController < ApplicationController
  before_action :authenticate_user!

  def index
    @deadlines = Deadline.all.order(:min_distance)
  end
end