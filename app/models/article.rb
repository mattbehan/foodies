class Article < ActiveRecord::Base
  include ContentHelper
  belongs_to :author, class_name: "User"

  validates :title, :content, :author_id, presence: true

  def get_preview
    self.content.split(" ")[0..90].join(" ")
  end
end
