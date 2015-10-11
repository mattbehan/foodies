class ReviewsController < ApplicationController
  before_action :set_review, only: [:show, :edit, :update, :destroy, :upvote, :downvote]
  before_action :set_restaurant, except: [:destroy, :upvote, :downvote]

  respond_to :html, :js, :json

  def new
    @review = Review.new
  end


  def create
    # This is a hardcoded solution.  At the time we don't have users, so we can't
    # create a new review unless we hardcode a user id.
    params[:review][:reviewer_id] = 1
    @review = Review.new(review_params)
    @review.restaurant = @restaurant
    if @review.save
      redirect_to restaurant_review_path(@restaurant, @review)
    else
      redirect_to new_restaurant_review_path
    end
  end

  def show
    @comments = @review.comments
  end

  def edit
  end

  def update
    if @review.update_attributes(review_params)
      redirect_to restaurant_review_path(@restaurant, @review)
    else
      redirect_to edit_restaurant_review_path
    end
  end

  def destroy
    @review.destroy
    redirect_to root_path
  end

  def upvote
    # p "In upvote"
    # if request.xhr?
    #   p "In xhr code"
    #   @vote = Vote.find_or_initialize_by(user_id: current_user.id, votable_type: "Review", votable_id: @review.id)
    #   new_value = @vote.value + 1
    #   @vote.update_attributes(value: new_value)
    # else
    #   p "Not in xhr"
    #   @vote = Vote.find_or_initialize_by(user_id: current_user.id, votable_type: "Review", votable_id: @review.id)
    #   new_value = @vote.value + 1
    #   @vote.update_attributes(value: new_value)
    #   redirect_to restaurant_review_path(@review.restaurant, @review)
    # end
  end

  def downvote
    @vote = Vote.find_or_initialize_by(user_id: current_user.id, votable_type: "Review", votable_id: @review.id)
    new_value = @vote.value - 1
    @vote.update_attributes(value: new_value)
    redirect_to restaurant_review_path(@review.restaurant, @review)
  end

  private

  def set_review
    @review = Review.find(params[:id])
  end

  def set_restaurant
    @restaurant = Restaurant.find(params[:restaurant_id])
  end

  def review_params
    params.require(:review).permit(:title, :content, :rating, :restaurant_id, :reviewer_id)
  end
end
