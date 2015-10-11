class ProfilesController < ApplicationController

	before_filter :must_be_logged_in
	# before_filter :find_user
	before_filter :find_profile, except: [:create]

	def new
		@profile = Profile.new
	end

	def create
		# redirect_to :show unless current_user.profile = nil
		@profile = Profile.new( profile_create_params.merge(user_id: current_user.id) )
		if @profile.save
			flash[:alert] = "Your profile has been created"
			redirect_to user_path(current_user)
		else
			render :new
		end
	end

	def edit
		must_be_owner(@profile)		
	end


	# bug where bio not auto updating.... have to manually set it
	def update
		must_be_owner(@profile)
		@profile.update(profile_update_params)
		@profile.bio = params[:profile][:bio]
		@profile.save
		if @profile.valid?
			flash[:alert] = "Profile updated"
			redirect_to user_path(current_user)
		else
			render :new
		end
	end

	protected

	def profile_create_params
    params.require(:profile).permit(:username, :full_name, :short_bio, :affiliation)
  end

	def profile_update_params
    params.require(:profile).permit(:full_name, :short_bio, :affiliation)
  end


end
