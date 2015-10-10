class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

	before_filter :configure_permitted_parameters, if: :devise_controller?

	helper_method :must_be_admin, :admin?


	def must_be_admin
		redirect_to unless current_user.admin?
	end

	def admin?
		current_user.admin?
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