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
    redirect_to :unknown_user if @user = nil
    @profile = Profile.find_by(user_id: params[:id])
    @new_user = User.new
  end

  def unknown_user

  end

    
    

  def top_reviewers
    @top_reviewers = User.top_ten_reviewers
  end

end
