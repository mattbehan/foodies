class SpecialtiesController < ApplicationController

  respond_to :html, :js, :json

  def create
    @restaurant = Restaurant.find(params[:restaurant_id])
    @dish = Dish.find_or_create_by(name: params[:name])
    @specialty = Specialty.find_or_initialize_by( dish_id: @dish.id, restaurant_id: @restaurant.id )

    if request.xhr?
      if @specialty.new_record? && @specialty.save
        #success = call create.js.erb
      else

      end
    else
      if @specialty.new_record? && @specialty.save
        flash[:alert] = "Added #{ @dish.name }"
        redirect_to :back
      elsif @specialty.save
        flash[:alert] = "#{@dish.name} already exists."
        redirect_to :back
      else
        flash[:alert] = "Invalid entry. Provide a dish name."
        redirect_to :back
      end
    end
  end

  def index
    @restaurant = Restaurant.find(params[:restaurant_id])
    @specialties = @restaurant.specialties
  end

  def upvote
    if request.xhr?
      prepare_upvote
    else
      prepare_upvote
      redirect_to :back
    end
  end

  def downvote
    if request.xhr?
      prepare_downvote
    else
      prepare_downvote
      redirect_to :back
    end
  end

  private

  def prepare_upvote
    prepare_vote
    new_value = @vote.value + 1
    @vote.update_attributes(value: new_value)
  end

  def prepare_downvote
    prepare_vote
    new_value = @vote.value - 1
    @vote.update_attributes(value: new_value)
  end

  def dish_params
    params.require(:dish).permit(:name)
  end

  def prepare_vote
    @specialty = Specialty.find(params[:id])
    @vote = Vote.find_or_initialize_by(user_id: current_user.id, votable_type: "Specialty", votable_id: @specialty.id)
  end

end
