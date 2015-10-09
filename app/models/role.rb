class Role < ActiveRecord::Base

	ROLES = %w(admin reviewer user)

	validates :name, presence: true, inclusion: {in: ROLES, message: "Invalid role" }

	belongs_to :user

end
