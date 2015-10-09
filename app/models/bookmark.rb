class Bookmark < ActiveRecord::Base
  belongs_to :bookmarked_restaurant, class_name: "Restaurant"
  belongs_to :bookmarker, class_name: "User"

  validates :bookmarker_id, :bookmarked_restaurant, presence: true
end
