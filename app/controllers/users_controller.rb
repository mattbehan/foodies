class UsersController < ApplicationController
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.

  before_filter :must_be_logged_in, only: [:reviewer_invite, :user_invite, :invite]
  before_filter :must_be_admin, only: [:reviewer_invite]
  before_filter :find_user, only: [:show]



  def invite
    @user = User.new
  end

  def user_invite
    User.invite_user!({email: params[:user][:email]}, current_user)
    redirect_to root_path
  end

  def reviewer_invite
    User.invite_reviewer!({email: params[:user][:email], role: "reviewer"}, current_user)
    redirect_to root_path
  end

  def show
    @profile = Profile.find_by(user_id: params[:id])
    @new_user = User.new
  end

  def show_finish_signup
    @identity = Identity.new(session["whee"])
    user = User.new(user_params)
  end

  def finish_signup
    
    
  end

end
