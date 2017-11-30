class Admin::RestaurantsController < ApplicationController

  before_action :authenticate_user!
  before_action :authenticate_admin

def index
  @restaurants = Restaurant.all
end

   def new
      @restaurant = Restaurant.new
   end

  def create
      @restaurant = Restaurant.new(restaurant_params)
      if @restaurant.save
        flash[:notice] = "Successfully created"
        redirect_to admin_restaurants_path
      else
        flash.now[:alert] = "Failed to create"
        render :new
      end
    end

  private

  def restaurant_params
    params.require(:restaurant).permit(:name, :opening_hours, :tel, :address, :description)
  end
end


