class RestaurantsController < ApplicationController

  def index
    if params[:search]
      @restaurants = Restaurant.search(params[:search]).order("name").page(params[:page]).per(5)

      # @articles = Article.search(params[:search]).order("created_at DESC")
    else
      @restaurants = Restaurant.order("name").page(params[:page]).per(5)
      # @articles = Article.order("created_at DESC")
    end
  end

  def show
    @restaurant = Restaurant.find(params[:id])
  end

end
