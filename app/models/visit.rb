class Visit < ActiveRecord::Base
  belongs_to :visitor, class_name: "User"
  belongs_to :visited_restaurant, class_name: "Restaurant"

  validates :visited_restaurant_id, :visitor_id, presence: true
end
