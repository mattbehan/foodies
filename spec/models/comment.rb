require 'spec_helper'
require 'rspec/rails'
require 'capybara/rails'
require 'shoulda-matchers'

describe Comment do

  it { should belong_to :user }
  it { should belong_to :reviewer }
  it { should have_many :votes }
  it { should validate_presence_of :content }
  it { should validate_presence_of :user_id }
  it { should validate_presence_of :review_id }

  describe "vote_count" do
    it "should return the score of the comment" do
      expect Comment.first.vote_count.to be_a_kind_of(Numeric)
    end
  end

  describe "good_comment?" do
    it "should return true or false based on the score of the comment" do
      if Comment.first.vote_count > -3
        expect(Comment.first.good_comment?).to be(true)
      else
        expect(Comment.first.good_comment?).to be(false)
      end
    end
  end

end
