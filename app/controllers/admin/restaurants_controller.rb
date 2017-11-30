class Admin::RestaurantsController < ApplicationController

  before_action :authenticate_user!
  before_action :authenticate_admin

def index
  @restaurants = Restaurant.all
end

end
