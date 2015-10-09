class Tagging < ActiveRecord::Base
  belongs_to :tag
  belongs_to :restaurant

  validates :tag_id, :restaurant_id, presence: true
end
