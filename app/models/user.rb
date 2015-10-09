class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable

  attr_writer :invitation_instructions

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

	def deliver_invitation
	 if @invitation_instructions.present?
	   ::Devise.mailer.send(@invitation_instructions, self).deliver
	 else
	   super
	 end
	end

	def self.invite_guest!(attributes={}, invited_by=nil)
	 self.invite!(attributes, invited_by) do |invitable|
	 	puts "invitable: ______________________________________________________________________________________________________________________________________________________________________"
	 	puts invitable
	   invitable.invitation_instructions = :guest_invitation_instructions
	 end
	end

	def self.invite_friend!(attributes={}, invited_by=nil)
	 self.invite!(attributes, invited_by) do |invitable|
	   invitable.invitation_instructions = :friend_invitation_instructions
	 end
	end

end

# display for users
#users can't have affiliation,  


# reviewers have everything
# reviewers must have confirmed email

# profile: full_name (required for reviewer), affiliation (reviewer only), bio (optional for both)

# someone will have to confirm reviewer
# 