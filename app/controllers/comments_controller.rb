class CommentsController < ApplicationController
  # before_action :set_comment, only: [:show, :edit, :update, :destroy]
  # # before_action :set_review, except: :destroy
  # before_action :set_restaurant, except: :destroy
  #
  # def new
  #   @comment = Comment.new
  # end

  respond_to :html, :js

  def create
    @restaurant = Restaurant.find(params[:restaurant_id])
    @review = Review.find_by(id: params[:id])
    @comment = Comment.new(comment_params)
    @comment.review = @review
    # Ajax NOW
    if @comment.save
      redirect_to restaurant_review_path(@restaurant, @review)
    else
      redirect_to restaurant_review_path(@restaurant, @review)
    end
  end

  def upvote
    prepare_vote  # Calls private method to set up vote for creation or update
    new_value = @vote.value + 1
    @vote.update_attributes(value: new_value)
    redirect_to :back
  end

  def downvote
    prepare_vote
    new_value = @vote.value - 1
    @vote.update_attributes(value: new_value)
    redirect_to :back
  end

  # def show
  # end
  #
  # def edit
  # end
  #
  # def update
  #   if @comment.update_attributes(comment_params)
  #     redirect_to restaurant_review_comment_path(@restaurant, @review, @comment)
  #   else
  #     redirect_to edit_restaurant_review_comment_path
  #   end
  # end
  #
  # def destroy
  #   @comment.destroy
  #   redirect_to root_path
  # end

  private

  # def set_comment
  #   @comment = Comment.find(params[:id])
  # end

  # def set_review
  #   @review = Review.find(params[:review_id])
  # end

  # def set_restaurant
  #   @restaurant = Restaurant.find(params[:restaurant_id])
  # end
  #
  def comment_params
    params.require(:comment).permit(:content, :review_id).merge(user_id: current_user.id)
  end

  def prepare_vote
    @comment = Comment.find(params[:id])
    @vote = Vote.find_or_initialize_by(user_id: current_user.id, votable_type: "Comment", votable_id: @comment.id)
  end
end
