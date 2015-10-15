class CommentsController < ApplicationController
  before_action :must_be_logged_in
  # before_action :current_user, only: [:create, :upvote, :downvote]
  respond_to :html, :js, :json

  def create
    @restaurant = Restaurant.find(params[:restaurant_id])
    @review = Review.find_by(id: params[:id])
    @comment = Comment.new(comment_params)
    @comment.review = @review

    if request.xhr?
      @comment.save
    else
      if @comment.save
        redirect_to :back
      else
        redirect_to :back
      end
    end
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

  def comment_params
    params.require(:comment).permit(:content, :review_id).merge(user_id: current_user.id)
  end

  def prepare_vote
    @comment = Comment.find(params[:id])
    @vote = Vote.find_or_initialize_by(user_id: current_user.id, votable_type: "Comment", votable_id: @comment.id)
  end
end
