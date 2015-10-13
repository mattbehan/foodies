# require 'gravatar_image_tag'

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
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

  # Returns the aggregate number of comments across a reviewers reviews
  def review_comment_count
    if reviewer_has_reviews?
      self.reviews.map { |review| review.comments.count }.inject(:+)
    else
      0
    end
  end

  # Returns the aggergate score of all comments for all of the users reviews
  def score_of_review_comments
    if reviewer_has_reviews?
      votes = 0
      self.reviews.each do |review|
        review.comments.each do |comment|
          votes += comment.vote_count
        end
      end
      votes
    else
      0
    end
  end

  # Returns the total amount of votes for all comments across all reviews, regardless of SCORE
  def review_comment_vote_count
    if reviewer_has_reviews?
      number_of_votes = 0
      self.reviews.each do |review|
        review.comments.each do |comment|
          number_of_votes += comment.votes.count
        end
      end
      number_of_votes
    else
      0
    end
  end

  # Returns the number of reviews authored by a user
  def number_of_reviews
    reviewer_has_reviews? ? self.reviews.count : 0
  end


  # Returns the total number of downvotes of all reviews
  def review_comment_downvote_count
    if reviewer_has_reviews?
      number_of_downvotes = 0
      self.reviews.each do |review|
        number_of_downvotes += Vote.where(votable_type: "Review",
                                          votable_id: review.id, value: -1).count
      end
      number_of_downvotes
    else
      0
    end
  end

  # Returns the vote-based score across all reviews for a reviewer
  def review_points
    if reviewer_has_reviews?
      self.reviews.map { |review| review.vote_count }.inject(:+)
    else
      0
    end
  end

  # Returns a users total points from comments
  def comment_points
    self.comments.map { |comment| comment.vote_count }.inject(:+)
  end

  def reviewer_reputation
    
  end

  def english_repuation

  end


  private

  def reviewer_has_reviews?
    self.role == "reviewer" && self.reviews.count > 0
  end

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
