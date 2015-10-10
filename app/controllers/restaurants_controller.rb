class RestaurantsController < ApplicationController
  before_action :set_restaurant

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
    @reviews = @restaurant.reviews
  end

  private

  def set_restaurant
    @restaurant = Restaurant.find(params[:id])
  end

end
