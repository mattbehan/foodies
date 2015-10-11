class FollowingsController < ApplicationController

	before_filter :must_be_signed_in
	before_filter( { find_owner(params[:resource], params[:resource_id]) } )

	def create
		Following.create(follower_id: current_user.id, followed_user_id: @owner)
		flash[:alert] = "User successfullly followed."
		redirect_to :back
	end

	def destroy
		@following = Following.find_by(follower_id: current_user, followed_user_id: @owner)
		must_be_owner(@following.follower_id)
		Following.destroy(@following.follower_id)
		flash[:alert] = "User unfollowed."
		redirect_to :back
	end

end