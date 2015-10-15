require "net/http"

class RestaurantsController < ApplicationController

  include ApplicationHelper

  before_action :set_restaurant, only: [:show, :edit, :update, :destroy]
  before_action :admin_or_reviewer?, only: [:new, :create, :edit, :update]

  def search
    lat_data = params["lat_data"]
    long_data = params["long_data"]
    if (params[:search] == "near") || (params[:search] == "nearby")
      params[:search] = ""
      @restaurants = Kaminari.paginate_array(Restaurant.filter("distance","",lat_data,long_data)).page(params[:page]).per(5)
    elsif (params[:search] == "food") || (params[:search] == "restaurants")
      params[:search] = ""
      @restaurants = Kaminari.paginate_array(Restaurant.filter("score","",lat_data,long_data)).page(params[:page]).per(5)
    else
      @restaurants = Kaminari.paginate_array(Restaurant.search(params[:search], lat_data, long_data)).page(params[:page]).per(5)
      calculate_aggregate_score
    end
  end

  def filter
    latitude = params[:lat_data]
    longitude = params[:long_data]
    search_query = params[:search]
    @filter_option = params[:type]
    @restaurants = Kaminari.paginate_array(Restaurant.filter(@filter_option,search_query,latitude,longitude)).page(params[:page]).per(5)

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
    tag_names = grab_tags
    if @restaurant.save
      tag_names.each do |tag_name|
        unless tag_name == ""
          tag_to_add = Tag.find_or_create_by(name: tag_name)
          @restaurant.tags << tag_to_add
        end
      end
      redirect_to @restaurant
    else
      @errors = @restaurant.errors.full_messages
      flash[:errors] = @errors
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
    tag_names = grab_tags
    if @restaurant.update_attributes(restaurant_params)

      # Delete existing restaurant tags from database (in order to enforce limit
      # of three tags per restaurant and make sure the right tags are deleted)
      @restaurant.tags = []
      tag_names.each do |tag_name|
        unless tag_name == ""
          tag_to_add = Tag.find_or_create_by(name: tag_name)
          @restaurant.tags << tag_to_add
        end
      end
      redirect_to restaurant_path
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

  def grab_tags
    [params[:restaurant].delete(:first_tag),
     params[:restaurant].delete(:second_tag),
     params[:restaurant].delete(:third_tag)]
  end

end
