class Vote < ActiveRecord::Base
  belongs_to :votable, :polymorphic => true
  belongs_to :user

  validates :value, presence: true, :inclusion => {:in => [-1,0,1]}
  validates :user_id, presence: true
  validates :votable_id, presence: true
  validates :votable_type, presence: true

end
