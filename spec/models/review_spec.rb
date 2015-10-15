require 'spec_helper'
require 'rspec/rails'
require 'capybara/rails'
require 'shoulda-matchers'

describe Review do

  it { should have_many :votes }
  it { should have_many :comments }
  it { should belong_to :restaurant }
  it { should belong_to :reviewer }
  it { should validate_presence_of :content }
  it { should validate_presence_of :rating }
  it { should validate_presence_of :restaurant_id }
  it { should validate_presence_of :reviewer_id }

  describe "vote_count" do
    it "should return a number representing the reviews score" do
      expect(Review.first.vote_count).to be_a_kind_of(Numeric)
    end
  end

end
