class FollowingsController < ApplicationController

	before_filter :find_owner(resource: params[:resource], params[:id])

	def create
	end

	def destroy
	end
end