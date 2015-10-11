class UsersController < ApplicationController
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.

  before_filter :must_be_logged_in, only: [:reviewer_invite, :user_invite, :invite]
  before_filter :must_be_admin, only: [:reviewer_invite]
  before_filter :find_user, only: [:show]

  def index
    @users = User.all
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
    @profile = Profile.find_by(id: params[:id])
  end

end