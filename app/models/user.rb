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

  # create a new user
  def self.from_omniauth auth
    raise auth.info.inspect
    where( provider: auth.provider, uid: auth.uid ).first_or_create do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.username = auth.info.nickname
    end
  end

  # set the attributes on the user so that it can pass the method sign_up
  def self.new_with_session params, session
    if session["devise.user_attributes"]
      # create a new user record based on the attributes in the hash. since we trust the hash it does not need to have protection
      new(session["devise.user_attributes"], without_protection: true) do |user|
        user.attributes = params
        user.valid?
      end
    else
      super
    end
  end

  def email_required?
    super && provider.blank?
  end

  # need to override so user can pass through the form without a password, given that a provider is present
  def password_required?
    super && provider.blank?
  end

  # on the edit form, if the user has never set a password, make it ok for them to update their account information. Also, we should change the edit form displayed so they don't see it if they don't have it
  def update_with_password params, *options
    if encrypted_password.blank?
      update_attributes(params, *options)
    else
      super
    end
  end

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

  # class method that calls the other, main class method. This and the following method overlay the default invite! by allowing two different methods to be called
	def self.invite_user!(attributes={role: "user"}, invited_by=nil)
	 self.invite!(attributes, invited_by)
	end

  #replaces just the invite method
	def self.invite_reviewer!(attributes={role: "admin"}, invited_by=nil)
	 self.invite!(attributes, invited_by)
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

  def reviews_near_aggregate
    if reviewer_has_reviews?
      points = 0
      self.reviews.each do |review|
        restaurant = Restaurant.find(review.restaurant_id)
        acceptable_range_high = restaurant.aggregate_score + 1
        acceptable_range_low = restaurant.aggregate_score - 1
        points += 1 if review.rating.between?(acceptable_range_low, acceptable_range_high)
      end
      points
    end
  end

  def downvoted_more_than_upvoted
    if reviewer_has_reviews?
      points = 0
      self.reviews.each do |review|
        if review.votes.where(value: -1).count > review.votes.where(value: 1).count
          points -= 2
        end
      end
    end
    points
  end

  # Returns a users total points from comments
  def comment_points
    self.comments.map { |comment| comment.vote_count }.inject(:+)
  end

  def reviewer_reputation
    points = 0
    points += (self.number_of_reviews * 10)
    points += self.reviews_near_aggregate
    points += self.downvoted_more_than_upvoted
    points += self.review_points / 2 unless self.review_points <= 0
    points -= self.review_comment_downvote_count / 2 unless self.review_comment_downvote_count <= 0
    points += self.review_comment_count
    points += self.comment_points
    points
  end

  def english_reviewer_repuation
    if self.reviewer_reputation.between?(0, 5)
      "Poor."
    elsif self.reviewer_reputation.between?(6, 10)
      "Fair."
    elsif self.reviewer_reputation.between?(11, 15)
      "Good."
    elsif self.reviewer_reputation.between?(16, 20)
      "Great!"
    elsif self.reviewer_reputation.between?(21, 25)
      "Most Excellent."
    elsif self.reviewer_reputation >= 26
      "Off the Charts!"
    else
      "Awful"
    end
  end

  def comment_count
    self.comments.count
  end

  def self.average_comment_count
    raw_comments = User.all.map { |u| u.comments.count }.inject(:+)
    raw_comments / User.all.count
  end

  def comment_often?
    self.comment_count >= User.average_comment_count
  end

  def upvote_downvote_ratio_points
    upvotes = 0
    downvotes = 0
    self.comments.each { |comment| upvotes += comment.votes.where(value: 1).count }
    self.comments.each { |comment| downvotes += comment.votes.where(value: -1).count }
    if user_has_comments? && upvotes >= downvotes
      upvotes - downvotes
    else
      0
    end
  end

  def times_voted
    self.votes.count
  end

  def times_upvoted
    self.votes.where(value: 1).count
  end

  def times_downvoted
    self.votes.where(value: -1).count
  end

  def user_reputation
    points = 0
    1.upto(self.comment_count) { points += (upvote_downvote_ratio_points * 1.5) }
    if self.comment_often?
      points += self.comment_points * (self.comment_count / 2)
    else
      points += self.comment_points * (self.comment_count / 4)
    end

    if self.times_upvoted >= self.times_downvoted
      points += self.times_voted
    else
      points += (self.times_voted / 2)
    end
    points
  end

  def english_user_reputation
    if self.user_reputation.between?(0, 15)
      "Poor."
    elsif self.user_reputation.between?(16, 30)
      "Decent."
    elsif self.user_reputation.between?(31, 45)
      "Good."
    elsif self.user_reputation.between?(46, 60)
      "Great!"
    elsif self.user_reputation.between?(61, 75)
      "Superb!"
    elsif self.user_reputation.between?(76, 100)
      "Super Excellent."
    elsif self.user_reputation >= 101
      "Off the charts!"
    else
      "Abysmal."
    end
  end

  private

  def reviewer_has_reviews?
    self.reviewer? && self.reviews.count > 0
  end

  def user_has_comments?
    self.user? && self.comment_count > 0
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
