class RestaurantsController < ApplicationController

  before_action :find_restaurant
  before_action :find_restaurants_reviews, only: [:show]

  def show
  end

  private

  def find_restaurant
    @restaurant = Restaurant.find(params[:id])
  end

  def find_restaurants_reviews
    @reviews = find_restaurant.reviews
  end

end
