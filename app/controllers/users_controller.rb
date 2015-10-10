class UsersController < ApplicationController
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.

  before_filter :must_be_logged_in, only: [:invite]
  before_filter :must_be_admin, only: [:reviewer_invite]

  

  def hey
    render :hey
  end

  def index
  end

  def invite
    @user = User.new
  end

  def user_invite
    User.invite_user!(email: params[:user][:email])
    redirect_to "/users/hey"
  end

  def reviewer_invite
    User.invite_reviewer!(email: params[:user][:email], role: "reviewer")
    redirect_to "/users/hey"
  end

  def show
  end

end