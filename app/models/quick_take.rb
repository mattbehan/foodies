class QuickTake < ActiveRecord::Base
  belongs_to :user
  belongs_to :restaurant

  validates :rater_id, :restaurant_id, :rating, presence: true
  validates_inclusion_of :rating, :in => 1..5
end
