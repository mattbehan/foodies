class OmniauthCallbacksController < Devise::OmniauthCallbacksController

	# based on the stuff from twitter, we want to see if that user exists or not. If not, we will create them with their twitter info and then sign them in, if they do, we will just sign them in
	def all
		user = User.from_omniauth(request.env["omniauth.auth"])
		if user.persisted?
			flash.notice = "Signed in"
			sign_in_and_redirect user
		else
			session["devise.user_attributes"] = user.attributes 
			redirect_to new_user_registration_url
		end
	end

	alias_method :twitter, :all

end
