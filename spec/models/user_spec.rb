require 'spec_helper'
require 'rspec/rails'
require 'capybara/rails'
require 'shoulda-matchers'

describe User do
  let(:user) { User.first }
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

  context "all_reviewers" do
    it "returns a collection of all reviewers" do
      expect(User.all_reviewers.count).to eq(User.where(role: "reviewer").count)
    end
  end


end
