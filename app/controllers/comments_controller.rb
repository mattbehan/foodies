class CommentsController < ApplicationController
  # before_action :set_comment, only: [:show, :edit, :update, :destroy]
  # # before_action :set_review, except: :destroy
  # before_action :set_restaurant, except: :destroy
  #
  # def new
  #   @comment = Comment.new
  # end


  def create
    @restaurant = Restaurant.find(params[:restaurant_id])
    @review = Review.find_by(id: params[:id])
    @comment = Comment.new(comment_params)
    @comment.review = @review

    # Ajax later
    if @comment.save
      redirect_to restaurant_review_path(@restaurant, @review)
    else
      redirect_to restaurant_review_path(@restaurant, @review)
    end
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
end
