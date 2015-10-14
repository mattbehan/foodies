class RestaurantsController < ApplicationController

  include ApplicationHelper

  before_action :set_restaurant, only: [:show, :edit, :update, :destroy]
  before_action :admin_or_reviewer?, only: [:new, :create, :edit, :update]

  def search
    # Search path
    if params[:search] == ""
      @restaurants = Restaurant.order("name").page(params[:page]).per(5)
      calculate_aggregate_score
    elsif params[:search]
      @restaurants = Restaurant.search(params[:search]).order("name").page(params[:page]).per(5)
      calculate_aggregate_score
    # Normal Render path
    else
      @restaurants = Restaurant.order("name").page(params[:page]).per(5)
      calculate_aggregate_score
    end
  end

  def filter
    @filter_option = params[:type]
    @restaurants = Kaminari.paginate_array(Restaurant.filter(@filter_option)).page(params[:page]).per(5)

    respond_to do |format|
      format.js {render 'filter'}
      format.html {}
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
    @rest_of_specialties = @restaurant.rest_of_dishes
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

  def calculate_aggregate_score
    @restaurants.each do |restaurant|
      restaurant.score = restaurant.aggregate_score
    end
  end

end
