class Specialty < ActiveRecord::Base
  belongs_to :restaurant
  belongs_to :dish
  has_many :votes, :as => :votable

  validates :restaurant_id, :dish_id, presence: true

  def vote_count
    votes.sum(:value)
  end



end
