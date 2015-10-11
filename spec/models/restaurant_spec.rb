require 'ffaker'
require 'spec_helper'
require 'rspec/rails'
require 'capybara/rails'
require 'shoulda-matchers' 

describe "Restaurant" do
  let(:restaurant) { Restaurant.first }

  context "initialization" do
    it "should exist" do
      expect(restaurant).to be_an_instance_of(Restaurant)
    end
  end

  context "validations" do
    it "should have many specialties" do
      expect(restaurant.specialties).to_not be(nil)
    end
  end

  describe '#top_three_dishes' do
    it "returns an array of three dishes sorted by their vote count" do
      expect(restaurant.top_three_dishes.count).to eq(3)
    end
  end

end
