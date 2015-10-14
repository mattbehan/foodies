require "net/http"

class RestaurantsController < ApplicationController

  include ApplicationHelper

  before_action :set_restaurant, only: [:show, :edit, :update, :destroy]
  before_action :admin_or_reviewer?, only: [:new, :create, :edit, :update]

  def search
    # Search path
    lat_data = params["lat-data"]
    long_data = params["long-data"]
    if params[:search] == "" # Return list of top 5 restaurants by score
      filter
    elsif params[:search]
      @restaurants = Kaminari.paginate_array(Restaurant.search(params[:search], lat_data, long_data)).page(params[:page]).per(5)
      calculate_aggregate_score
    # Normal Render path (handle the unexpected)
    else
      filter
    end
  end

  def filter
    search_query = params[:search]
    @filter_option = params[:type] || "score"
    @restaurants = Kaminari.paginate_array(Restaurant.filter(@filter_option,search_query)).page(params[:page]).per(5)

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
