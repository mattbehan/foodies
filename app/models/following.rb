class Following < ActiveRecord::Base
  belongs_to :user
  belongs_to :follower, class_name: "User"

  validates :user_id, :follower_id, presence: true
end
