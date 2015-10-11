class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :review
  has_many :votes, :as => :votable

  validates :content, :user_id, :review_id, presence: true

  def vote_count
    self.votes.inject(0) { |total, vote| total += vote.value }
  end

  def good_comment?
    self.vote_count > -3
  end
end
