class Dish < ActiveRecord::Base
  has_many :specialties
  has_many :restaurants, through: :specialties

  validates :name, presence: true

  def vote_count
    self.votes.inject(0) { |total| total += vote.value }
  end

end
