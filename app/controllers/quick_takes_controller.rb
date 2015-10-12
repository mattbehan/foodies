class QuickTakesController < ApplicationController

  before_action :set_restaurant

  respond_to :html, :js, :json

  def new
    @quick_take = QuickTake.new
  end

  # Needs to be cleaned UP
  def create
    @quick_take = QuickTake.new(quick_take_params)
    if request.xhr?
      if @quick_take.save
        flash.now[:thanks] = "Thanks! Your rating has been saved!"
      # redirect_to @restaurant
      else
        redirect_to :back
      end
    else
      if @quick_take.save
        flash[:thanks] = "Thanks! Your rating has been saved!"
        redirect_to @restaurant
      else
        redirect_to :back
      end
    end
  end

  private

  def set_restaurant
    @restaurant = Restaurant.find(params[:restaurant_id])
  end

  def quick_take_params
    params.require(:quick_take).permit(:rating).merge(rater_id: current_user.id, restaurant_id: @restaurant.id)
  end
end
