class RestaurantsController < ApplicationController

  def index
    # Search path
    if params[:search]
      @restaurants = Restaurant.search(params[:search]).order("name").page(params[:page]).per(5)
    # Normal Render path
    else
      @restaurants = Restaurant.order("name").page(params[:page]).per(5)
    end
  end

  def show
    @restaurant = Restaurant.find(params[:id])
  end

end
