class RegistrationsController < Devise::RegistrationsController

  # in controller it is just @user.new
  # render "/users/registrations/new"
  def register
    if session["devise.user_attributes"] == nil
      @user = User.new
    else
      @user = User.new(email: session["devise.user_attributes"]["email"], provider: session["devise.user_attributes"]["provider"], username: session["devise.user_attributes"]["username"])
    end
    render "users/registrations/new"
  end

  def create
    if session["devise.user_attributes"]
      provider = session["devise.user_attributes"]["provider"]
    end
    build_resource(sign_up_params.merge(provider: provider))
    resource.save
    yield resource if block_given?
    if resource.persisted?
      if resource.active_for_authentication?
        set_flash_message :notice, :signed_up if is_flashing_format?
        sign_up(resource_name, resource)
        redirect_to new_user_profile_path(resource)
      else
        set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}" if is_flashing_format?
        expire_data_after_sign_in!
        redirect_to new_user_profile_path(resource)
      end
    else
      clean_up_passwords resource
      set_minimum_password_length
      respond_with resource
    end
  end

  def finish_signup
    # authorize! :update, @user 
    if request.patch? && params[:user] #&& params[:user][:email]
      if @user.update(finish_params)
        @user.skip_reconfirmation!
        sign_in(@user, :bypass => true)
        redirect_to @user, notice: 'Your profile was successfully updated.'
      else
        @show_errors = true
      end
    end
  end

  def update_resource(resource, params)
    if resource.encrypted_password.blank? # || params[:password].blank?
      resource.email = params[:email] if params[:email]
      if !params[:password].blank? && params[:password] == params[:password_confirmation]
        logger.info "Updating password"
        resource.password = params[:password]
        resource.save
      end
      if resource.valid?
        resource.update_without_password(params)
      end
    else
      resource.update_with_password(params)
    end
  end

  def edit
    render :"users/registrations/edit"
  end

  # The path used after sign up
  def after_sign_up_path_for(resource)
    after_sign_in_path_for(resource)
    root_path
  end

  # The path used after sign up for inactive accounts
  def after_inactive_sign_up_path_for(resource)
    scope = Devise::Mapping.find_scope!(resource)
    router_name = Devise.mappings[scope].router_name
    context = router_name ? send(router_name) : self
    context.respond_to?(:root_path) ? context.root_path : "/"
    # context.respond_to?(:index) ? context.index : "/users"
  end

  # The default url to be used after updating a resource
  def after_update_path_for(resource)
    signed_in_root_path(resource)
  end

  protected

  def finish_params
    accessible = [ :username, :email, :password, :password_confirmation ]
    params.require(:user).permit(accessible)
  end

  def sign_up_params
    params.require(:user).permit(:email, :username, :password, :password_confirmation)
  end



end
