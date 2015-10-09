class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :review
  has_many :votes, :as => :votable

  validates :content, :user_id, :review_id, presence: true

  def vote_count
    self.votes.inject(0) { |total| total += vote.value }
  end
end
