class Admin::RestaurantsController < ApplicationController

  before_action :authenticate_user!
  before_action :authenticate_admin
  before_action :set_restaurant, only: [:show, :edit, :update, :destroy]

def index
  @restaurants = Restaurant.page(params[:page]).per(9)
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

    def show
    end

    def edit
    end

    def update
      if @restaurant.update(restaurant_params)
        redirect_to admin_restaurants_path(@restaurant)
        flash[:notice] = "Successfully updated"
      else
        render :edit
        flash[:alert] = "Failed to update"
      end
  end

  def destroy
    @restaurant.destroy
    redirect_to admin_restaurants_path
    flash[:alert] = "Successfully deleted"
  end
 


  private

  def restaurant_params
    params.require(:restaurant).permit(:name, :opening_hours, :tel, :address, :description, :image)
  end

  def set_restaurant
    @restaurant = Restaurant.find(params[:id])
    
  end
end


