class Article < ActiveRecord::Base
  include ContentHelper
  belongs_to :author, class_name: "User"

  validates :title, :content, :author_id, presence: true
end
