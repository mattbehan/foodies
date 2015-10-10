class RestaurantsController < ApplicationController

  def index
    @restaurants = Restaurant.order("name").page(params[:page]).per(5)
  end

  def show
    @restaurant = Restaurant.find(params[:id])
  end

end
