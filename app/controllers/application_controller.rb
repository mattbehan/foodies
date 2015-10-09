class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def after_sign_in_path_for(resource)
  	user_path(current_user)
  end

  def after_sign_out_path_for(resource_or_scope)
  	root_path
  end

  def after_sign_up_path_for(resource)
    "/users"
  end

  def after_inactive_sign_up_path_for(resource)
    scope = Devise::Mapping.find_scope!(resource)
    router_name = Devise.mappings[scope].router_name
    context = router_name ? send(router_name) : self
    # context.respond_to?(:root_path) ? context.root_path : "/"
    context.respond_to?(:index) ? context.index : "/users"
  end


end