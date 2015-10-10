class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

	before_filter :configure_permitted_parameters, if: :devise_controller?

	helper_method :must_be_admin, :admin?, :must_be_logged_in, :find_user, :find_profile, :must_be_owner, :owner?

	def owner

	end

	# redirect route should be changed
	def must_be_owner resource
		redirect_to new_user_session_path unless owner?(resource)
	end

	def owner? resource
		resource.user_id == current_user.id
	end

	def find_user
		@user = current_user
	end

	def find_profile
		@profile = current_user.profile
	end

	def must_be_logged_in
		redirect_to new_user_session_path unless user_signed_in?
	end


	def must_be_admin
		redirect_to root_path unless admin?
	end

	def admin?
		user_signed_in? && current_user.admin?
	end


  def after_sign_in_path_for(resource)
  	user_path(current_user)
  end

  def after_sign_out_path_for(resource_or_scope)
  	root_path
  end


	protected

	def configure_permitted_parameters
	  # # Only add some parameters
	  # devise_parameter_sanitizer.for(:accept_invitation).concat [:first_name, :last_name, :phone]
	  # Override accepted parameters
	  devise_parameter_sanitizer.for(:accept_invitation) do |u|
	    u.permit(:username, :password, :password_confirmation,
	             :invitation_token)
	  end

    devise_parameter_sanitizer.for(:sign_up) << :username
	end


end