class OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def instagram
    generic_callback( 'instagram' )
  end

  def facebook
    generic_callback( 'facebook' )
  end

  def twitter
    generic_callback( 'twitter' )
  end

  def generic_callback( provider )
    @identity = Identity.find_for_oauth env["omniauth.auth"]

    @user = @identity.user || current_user
    if @user.nil?
      @user = User.create( email: @identity.email || "" )
      @identity.update_attribute( :user_id, @user.id )
    end

    if @user.email.blank? && @identity.email
      @user.update_attribute( :email, @identity.email)
    end

    if @user.persisted?
      @identity.update_attribute( :user_id, @user.id )
      # This is because we've created the user manually, and Device expects a
      # FormUser class (with the validations)
      @user = User.find @user.id
      flash[:notice] = "Signed in"
      sign_in_and_redirect @user, event: :authentication
    else
      session["devise.#{provider}_data"] = env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
  end

	# # based on the stuff from twitter, we want to see if that user exists or not. If not, we will create them with their twitter info and then sign them in, if they do, we will just sign them in
	# def all
	# 	user = User.from_omniauth(request.env["omniauth.auth"])
	# 	if user.persisted?
	# 		flash[:notice] = "Signed in"
	# 		sign_in_and_redirect user
	# 	else
	# 		session["devise.user_attributes"] = user.attributes 
	# 		redirect_to new_user_registration_url
	# 	end
	# end

	# alias_method :twitter, :all

end
