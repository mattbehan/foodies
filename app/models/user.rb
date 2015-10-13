# require 'gravatar_image_tag'

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable

  include ApplicationHelper

  attr_writer :invitation_instructions

  ROLES = %w(user reviewer admin)

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :lockable, :confirmable, :invitable, :omniauthable

 	has_one :profile


  has_many :followings, foreign_key: "follower_id"
  has_many :followed_users, through: :followings
  has_many :bookmarks, foreign_key: "bookmarker_id"
  has_many :bookmarked_restaurants, through: :bookmarks
  has_many :votes
  has_many :articles, foreign_key: "author_id"
  has_many :comments
  has_many :commented_upon_reviews, through: :comments, source: :review
  has_many :reviews, foreign_key: "reviewer_id"
  has_many :reviewed_restaurants, through: :reviews, source: :restaurant
  has_many :quick_takes, foreign_key: "rater_id"
  has_many :rated_restaurants, through: :quick_takes, source: :restaurant
  has_many :visits, foreign_key: "visitor_id"
  has_many :visited_restaurants, through: :visits

  validates :role, presence: true,
    inclusion: {in: ROLES, message: "Invalid role" }
  validates :username, presence: true, uniqueness: true

  def has_visited? restaurant_id
    visits.find_by(visited_restaurant_id: restaurant_id) != nil
  end

  def has_bookmarked? restaurant_id
    bookmarks.find_by(bookmarked_restaurant_id: restaurant_id) != nil
  end

  def follows? other_user_id
    followings.find_by(followed_user_id: other_user_id ) != nil
  end

  def followers
    following_relationships = Following.where(followed_user_id: self.id).map{ |following_relationship| following_relationship.follower }
  end

 	def admin?
 		role == "admin"
 	end

 	def user?
 		role == "user"
 	end

 	def reviewer?
 		role == "reviewer"
 	end

 	def self.all_users
 		User.all.select {|user| user.role == "user"}
 	end

 	def self.all_admins
 		User.all.select {|user| user.role == "admin"}
 	end

 	def self.all_reviewers
 		User.all.select {|user| user.role == "reviewer"}
 	end

  # def get_gravatar
  #   show_gravatar(self)
  # end


	def deliver_invitation
	 if @invitation_instructions.present?
	   ::Devise.mailer.send(@invitation_instructions, self).deliver
	 else
	   super
	 end
	end

    # devise confirm! method overriden
  # def confirm!
  #   welcome_message
  #   super
  # end

  # devise_invitable accept_invitation! method overriden
  def accept_invitation!
    self.confirm!
    super
  end




  # class method that calls the other, main class method. This and the following method overlay the default invite! by allowing two different methods to be called
	def self.invite_user!(attributes={role: "user"}, invited_by=nil)
	 self.invite!(attributes, invited_by) do |invitable|
	   invitable.invitation_instructions = :user_invitation_instructions
	 end
	end

  #replaces just the invite method
	def self.invite_reviewer!(attributes={role: "admin"}, invited_by=nil)
	 self.invite!(attributes, invited_by) do |invitable|
	   invitable.invitation_instructions = :reviewer_invitation_instructions
	 end
	end

  def already_quick_took?(restaurant)
    self.quick_takes.any? { |qt| qt.restaurant_id == restaurant.id }
  end

  def random_avatar
    food_photos = [
      "/app/assets/images/apples_and_bananas.jpg",
      "/app/assets/images/bento_box.jpg",
      "/app/assets/images/breakfast_croissants.jpg",
      "/app/assets/images/chocolate_doughnut.jpg",
      "/app/assets/images/dessert.jpg",
      "/app/assets/images/fast_food_meal.jpg",
      "/app/assets/images/fried_breakfast.jpg",
      "/app/assets/images/pizza.jpg",
      "/app/assets/images/ramen.jpg",
      "/app/assets/images/strawberries_halved.jpg"
    ]
    food_photos.sample
  end


# private

#   def welcome_message
#     UserMailer.welcome_message(self).deliver
#   end

end

# display for users
#users can't have affiliation,


# reviewers have everything
# reviewers must have confirmed email

# profile: full_name (required for reviewer), affiliation (reviewer only), bio (optional for both)

# someone will have to confirm reviewer
#
