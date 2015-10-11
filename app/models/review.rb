class Review < ActiveRecord::Base
  has_many :votes, :as => :votable
  has_many :comments
  belongs_to :restaurant
  belongs_to :reviewer, class_name: "User"

  validates :title, :content, :rating, :restaurant_id, :reviewer_id, presence: true
  # validates_inclusion_of :rating, :in => 1..5

  def vote_count
    self.votes.inject(0) { |total, vote| total += vote.value }
  end

end
