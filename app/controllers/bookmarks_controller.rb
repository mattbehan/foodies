class BookmarksController < ApplicationController

	respond_to :html, :js, :json

	before_filter :must_be_logged_in

	def create
		@bookmark = Bookmark.find_or_initialize_by(bookmarked_restaurant_id: params[:restaurant_id], bookmarker_id: current_user.id )
		if @bookmark.new_record?
			@bookmark.save
			if request.xhr?
				return "Bookmark created"
			end
			flash[:bookmark] = "Bookmark created"
		end
		redirect_to :back
	end

	def destroy
		@bookmark = Bookmark.find_by(bookmarked_restaurant_id: params[:id], bookmarker_id: current_user.id)
		Bookmark.destroy(@bookmark.id)
		if request.xhr?
			return "Bookmark removed"
		end
		flash[:bookmark] = "Bookmark removed"
		redirect_to :back
	end

end