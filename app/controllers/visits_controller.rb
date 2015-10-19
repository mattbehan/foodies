class VisitsController < ApplicationController

	before_filter :must_be_logged_in

	respond_to :html, :js, :json

		def create
		@restaurant = Restaurant.find(params[:restaurant_id])
		@visit = Visit.find_or_initialize_by(visited_restaurant_id: params[:restaurant_id], visitor_id: current_user.id )
		if @visit.new_record?
			# @visit.save
			if request.xhr?
				return "Visit created"
			end
			flash[:visit] = "Visit created"
		else
			flash[:visit] = "Already Visited"
		end
		redirect_to :back
	end

end

