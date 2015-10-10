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


end
