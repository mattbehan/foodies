require 'spec_helper'
require 'rspec/rails'
require 'capybara/rails'
require 'shoulda-matchers'

describe QuickTake do
  it { should belong_to :rater }
  it { should belong_to :restaurant }
  it { should validate_presence_of :rater_id }
  it { should validate_presence_of :restaurant_id }
  it { should validate_presence_of :rating }


  it "should not save to the database if invalid" do
    qt = QuickTake.new(rater_id: 1, restaurant_id: 1, rating: 10)
    expect(qt.valid?).to be(false)
  end
end
