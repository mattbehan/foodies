class Specialty < ActiveRecord::Base
  belongs_to :restaurant
  belongs_to :dish

  validates :restaurant_id, :dish_id, presence: true
end
