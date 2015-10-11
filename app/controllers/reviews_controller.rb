class ReviewsController < ApplicationController

  include ApplicationHelper

  before_action :set_review, only: [:show, :edit, :update, :destroy, :upvote, :downvote]
  before_action :set_restaurant, except: [:destroy, :upvote, :downvote]
  before_action :authorized_reviewer?, only: [:new, :create]
  before_action :review_creator?, only: [:edit, :update, :destroy]
  before_action :authorized_admin?, only: [:destroy]

  respond_to :html, :js, :json

  def new
    @review = Review.new
  end


  def create
    @review = Review.new(review_params)
    @review.restaurant = @restaurant
    if @review.save!
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
    if request.xhr?
      prepare_upvote

    else
      prepare_upvote

      redirect_to :back
    end
  end

  def downvote
    if request.xhr?
      prepare_upvote
    else
      prepare_downvote
      redirect_to :back
    end
  end

  private

  def prepare_upvote
    @vote = Vote.find_or_initialize_by(user_id: current_user.id, votable_type: "Review", votable_id: @review.id)
    new_value = @vote.value - 1
    @vote.update_attributes(value: new_value)
  end

  def prepare_downvote
    @vote = Vote.find_or_initialize_by(user_id: current_user.id, votable_type: "Comment", votable_id: @comment.id)
    new_value = @vote.value - 1
    @vote.update_attributes(value: new_value)
  end

  def set_review
    @review = Review.find(params[:id])
  end

  def set_restaurant
    @restaurant = Restaurant.find(params[:restaurant_id])
  end

  def review_params
    params.require(:review).permit(:title, :content, :rating, :restaurant_id).merge(reviewer_id: current_user.id)
  end
end
