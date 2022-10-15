class DeadlinesController < ApplicationController

  def index
    @deadlines = Deadline.all.order(:min_distance)
  end
end