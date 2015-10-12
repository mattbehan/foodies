class BookmarksController < ApplicationController

	def create
		@bookmark = Bookmark.new(restaurant_id: params[:restaurant_id], user_id: current_user.id )
	end

	def destroy
		@bookmark = Bookmark.find(params[:id])
		must_be_owner(@bookmark.id)
		Bookmark.destroy(@bookmark.id)
	end

end