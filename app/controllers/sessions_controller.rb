class SessionsController < Devise::SessionsController

  def new
    @user = User.new
    render :"users/sessions/new"
  end

   def create
		self.resource = warden.authenticate!(auth_options)
    set_flash_message(:notice, :signed_in) if is_navigational_format?
    sign_in(resource_name, resource)
    if !session[:return_to].blank?
      redirect_to root_path
    else
    	if session[:user_id] == nil
    		redirect_to root_path
	    else
	      respond_with resource, :location => after_sign_in_path_for(resource)
	    end
    end
  end

  # edit method here? or does this direct to edit_user_password_path?

end
