class SessionsController < Devise::SessionsController

  def new
    @user = User.new
    render :"users/sessions/new"
  end

  def create
    super
  end

  # edit method here? or does this direct to edit_user_password_path?

end
