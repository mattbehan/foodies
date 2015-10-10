class RestaurantsController < ApplicationController

  before_action :set_restaurant

  def show
    @reviews = @restaurant.reviews
  end

  private

  def set_restaurant
    @restaurant = Restaurant.find(params[:id])
  end

end
