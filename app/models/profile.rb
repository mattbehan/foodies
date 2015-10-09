class Profile < ActiveRecord::Base
	belongs_to :user

	validates :username, presence: true 
end
