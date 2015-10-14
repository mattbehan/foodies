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
  	session[:provider]=provider
    @identity = Identity.find_for_oauth env["omniauth.auth"]
    # this is how we are going to identify users signing in through social media sites
    @user = @identity.user || current_user
    if @user.nil?
      @user = User.new( email: @identity.email || "" )
    end

    if @user.email.blank? && @identity.email
      @user.email = @identity.email
      session[:email] = @identity.email
    end
    if @user.username == nil && @identity.nickname
    	session[:username] = @identity.nickname
    	@user.username = @identity.nickname
    end

    @user.provider = provider

    if @user.persisted?
      @identity.update_attribute( :user_id, @user.id )
      @user.save
      flash[:notice] = "Signed in"
      sign_in_and_redirect @user, event: :authentication
    else
    	@user.save(validate: false)
      @identity.update_attribute( :user_id, @user.id )
      redirect_to finish_signup_path(@user)
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
