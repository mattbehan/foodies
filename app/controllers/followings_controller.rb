class FollowingsController < ApplicationController

	before_filter :must_be_logged_in
	before_filter { find_owner(params[:resource], params[:resource_id]) }
	before_filter :set_profile

	respond_to :html, :js, :json

	def create
		p "in create"
		if request.xhr?
			Following.create(follower_id: current_user.id, followed_user_id: @owner)
		else
			Following.create(follower_id: current_user.id, followed_user_id: @owner)
			flash[:alert] = "User successfully followed."
			redirect_to :back
		end
	end

	def destroy
		if request.xhr?
			@following = Following.find_by(follower_id: current_user.id, followed_user_id: @owner)
			must_be_owner(@following.follower_id)
			Following.destroy(@following.id)
		else
			@following = Following.find_by(follower_id: current_user.id, followed_user_id: @owner)
			must_be_owner(@following.follower_id)
			Following.destroy(@following.id)
			flash[:alert] = "User unfollowed."
			redirect_to :back
		end
	end

	private

	def set_profile
		@profile = Profile.find(params[:resource_id])
	end

end
