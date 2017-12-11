class RestaurantsController < ApplicationController

  def index
    @restaurants = Restaurant.page(params[:page]).per(9)
  end

end
