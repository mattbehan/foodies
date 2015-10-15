


require 'spec_helper'
require 'rspec/rails'
require 'capybara/rails'
require 'shoulda-matchers'

describe User do
  let(:user) { User.first }
  let(:other_user) { User.second }
  let(:another_user) { User.third }
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:password) }
  it { should have_many(:visits) }
  it { should have_many(:bookmarks) }
  it { should have_many(:quick_takes) }
  it { should have_many(:reviews) }
  it { should have_many(:comments) }
  it { should have_many(:articles) }
  it { should have_many(:votes) }

  context "followers" do
    it "should return a collection of a users followers" do
      expect(user.followers).to_not be(nil)
    end

    it "has the ability to extract a certain follower" do
      expect(user.followers.first).to be_an_instance_of(User)
    end
  end

  context "admin?" do
    it "returns true if the user is an admin" do
      user.role = "admin"
      expect(user.admin?).to eq(true)
    end
  end

  context "user?" do
    it "returns true if the user is not an admin and is a user" do
      user.role = "user"
      expect(user.user?).to eq(true)
    end
  end

  context "reviewer?" do
    it "returns true if the user is a reviewer" do
      user.role = "reviewer"
      expect(user.reviewer?).to eq(true)
    end
  end

  context "all_users" do
    it "returns a collection of users" do
      expect(User.all_users.count).to eq(User.where(role: "user").count)
    end
  end

  context "all_admins" do
    it "returns a collection of all admins" do
      expect(User.all_admins.count).to eq(User.where(role: "admin").count)
    end
  end

  context "top_ten_reviewers" do
    it "returns a collection of reviewers" do
      User.first(10).each { |r| r.role = "reviewer"; r.save }
      expect(User.top_ten_reviewers.all? { |x| x.role == "reviewer" }).to be true
    end
  end

  context "reviewer_reputation" do
    it "should return a numeric representation of that reviewers reputation" do
      user.role = "reviewer"
      user.save
      expect(user.reviewer_reputation).to be_a_kind_of(Numeric)
    end

    it "should return 0 if the user is not set as a reviewer" do
      user.role = "user"
      user.save
      expect(user.reviewer_reputation).to eq(0)
    end
  end

  context "english_reviewer_reputation" do
    valid_responses = %w(Poor. Fair. Good. Great! Most Excellent. Off the Charts!)
    it "should return a string representation of that reviewers reputation" do
      user.role = "reviewer"
      user.save
      expect(valid_responses).to include(user.english_reviewer_reputation)
    end

    it "should return 'poor' when run on a user who is not a reviewer" do
      user.role = "user"
      user.save
      expect(user.english_reviewer_reputation).to eq("Poor.")
    end
  end

  context "comment_count" do
    it "should return a number representing the amount of tiimes a user has commented" do
      expect(user.comment_count).to be_a_kind_of(Numeric)
    end

    it "should equal the amount of comments saved in the database" do
      expect(user.comment_count).to eq(user.comments.count)
    end

    it "should return 0 when a user has no comments" do
      user.comments.each { |c| c.destroy }
      user.save
      expect(user.comment_count).to eq(0)
    end
  end

  context "average_comment_count" do
    it "should return the site-wide average number of comments per user" do
      expect(User.average_comment_count).to be_a_kind_of(Numeric)
    end
  end

  context "user_reputation" do
    it "should return a numeric representation of users site reputation" do
      other_user.role = "user"
      other_user.save
      expect(other_user.user_reputation).to be_a_kind_of(Numeric)
    end

    it "should return 0 if the user is a reviewer" do
      other_user.role = "reviewer"
      other_user.save
      expect(other_user.user_reputation).to eq(0)
    end

    it "should return 0 if the user is an admin" do
      other_user.role = "admin"
      other_user.save
      expect(other_user.user_reputation).to eq(0)
    end
  end

  context "english_user_reputation" do
    acceptable_outputs = %w(Poor. Decent. Good. Great! Superb! Super Excellent. Off the Charts! Abysmall.)
    it "should return a string representation of a users reputation" do
      other_user.role = "user"
      expect(acceptable_outputs).to include(other_user.english_user_reputation)
    end
  end

end
