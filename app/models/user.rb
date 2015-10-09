class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :lockable, :confirmable, :invitable

 	has_one :profile
 	has_one :role

 	def admin?
 		role.name == "admin"
 	end

 	def user?
 		role.name == "user"
 	end

 	def reviewer?
 		role.name == "reviewer"
 	end

 	def self.all_users
 		User.all.select {|user| user.role.name == "user"}
 	end

 	def self.all_admins
 		User.all.select {|user| user.role.name == "admin"}
 	end

 	def self.all_reviewers
 		User.all.select {|user| user.role.name == "reviewer"}
 	end

end

# display for users
#users can't have affiliation,  


# reviewers have everything
# reviewers must have confirmed email

# profile: full_name (required for reviewer), affiliation (reviewer only), bio (optional for both)

# someone will have to confirm reviewer
# 