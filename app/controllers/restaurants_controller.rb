class RestaurantsController < ApplicationController

  include ApplicationHelper

  before_action :set_restaurant, only: [:show, :edit, :update, :destroy]
  before_action :admin_or_reviewer?, only: [:new, :create, :edit, :update]

  def search
    # Search path
    if params[:search] == ""
      @restaurants = Restaurant.order("name").page(params[:page]).per(5)
    elsif params[:search]
      @restaurants = Restaurant.search(params[:search]).order("name").page(params[:page]).per(5)
    # Normal Render path
    else
      @restaurants = Restaurant.order("name").page(params[:page]).per(5)
    end
  end

  def new
    @restaurant = Restaurant.new
  end

  def create
    @restaurant = Restaurant.new(restaurant_params)
    if @restaurant.save
      redirect_to @restaurant
    else
      redirect_to new_restaurant_path
    end
  end

  def show
    @reviews = @restaurant.reviews
    @specialties = @restaurant.top_three_dishes
    @all_specialties = @restaurant.specialties
    @rest_of_specialties = @restaurant
    @new_specialty = Specialty.new
  end

  def edit
  end

  def update
    if @restaurant.update_attributes(restaurant_params)
      redirect_to @restaurant
    else
      redirect_to edit_restaurant_path
    end
  end

  private

  def set_restaurant
    @restaurant = Restaurant.find(params[:id])
  end

  def restaurant_params
    params.require(:restaurant).permit(:name, :cuisine, :street_address, :city,
                                        :state, :zip, :phone_number, :neighborhood,
                                        :nearest_l, :website, :menu_url, :price_scale,
                                        :atmosphere, :delivery, :reservations,
                                        :vegan_friendliness, :patios, :dress_code)
  end

end
