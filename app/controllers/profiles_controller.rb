class ProfilesController < ApplicationController

	before_filter :must_be_logged_in
	before_filter :find_user
	before_filter :find_profile

	def new
		@profile =Profile.new
	end

	def create
	end

	def show
	end

	def edit
		redirect 
	end

	def update
	end
end
