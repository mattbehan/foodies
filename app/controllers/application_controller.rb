class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

	before_filter :configure_permitted_parameters, if: :devise_controller?


	helper_method :must_be_admin, :admin?, :must_be_logged_in, :find_user, :find_profile, :must_be_owner, :owner?, :find_owner, :wipe_provider, :current_identity, :virtual_sign_in?

	def virtual_sign_in?
		session[:provider] != nil
	end

	def current_identity
		return current_user.identities.find_by(provider: current_user.provider) if user_signed_in?
	end

	def wipe_provider
		current_user.provider = nil
	end

	def find_owner(resource, resource_id)
		return @owner = resource_id.to_i if resource == "User"
		@resources_class = Object.const_get(resource)
		@owner = @resources_class.find_by(id: resource_id).user_id
	end

	def must_be_owner resource_users_id
		unless owner?(resource_users_id)
			flash[:alert] = "You are not authorized to take that action"
			redirect_to :back
		end
	end

	def owner? resource_users_id
		user_signed_in? && resource_users_id.to_i == current_user.id
	end


	def find_profile
		@profile = Profile.find_by(id: params[:id])
	end

	def find_user
		@user = User.find_by(id: params[:id])
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

  def after_invite_path_for resource
  	users_path
  end


	protected

	def configure_permitted_parameters
	  # devise_parameter_sanitizer.for(:accept_invitation).concat [:first_name, :last_name, :phone]
	  # Override accepted parameters
	  devise_parameter_sanitizer.for(:accept_invitation) do |u|
	    u.permit(:username, :password, :password_confirmation,
	             :invitation_token)
	  end

    devise_parameter_sanitizer.for(:sign_up) << :username
	end


end
