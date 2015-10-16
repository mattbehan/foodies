

require 'ffaker'
require 'spec_helper'
require 'rspec/rails'
require 'capybara/rails'
require 'shoulda-matchers'

describe Restaurant do
  let(:restaurant) { Restaurant.first }
  let(:second_restaurant) { Restaurant.last }
  let(:review) { Review.create(title: "Test title", content: "Test content",
                                rating: 4, restaurant_id: second_restaurant.id,
                                reviewer_id: 1)}
  let(:third_restaurant) { Restaurant.second }
  let(:quick_take) { QuickTake.create(rater_id: 1, restaurant_id: third_restaurant.id,
                                       rating: 4)}

  # Validators
  it { should validate_presence_of :name }
  it { should validate_presence_of :street_address }
  it { should validate_presence_of :city }
  it { should validate_presence_of :zip }
  it { should validate_presence_of :price_scale }

  # Associations
  it { should have_many :taggings }
  it { should have_many :reviews }
  it { should have_many :bookmarks }
  it { should have_many :quick_takes }
  it { should have_many :raters }
  it { should have_many :specialties }
  it { should have_many :dishes }
  it { should have_many :visits }
  it { should have_many :visitors }

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

  describe '#aggregate_score' do
    it "returns a number that is an average of all it's reviewed scores" do
      expect(restaurant.aggregate_score).to be_a_kind_of(Numeric)
    end

    it "still returns a number if only reviews exist" do
      second_restaurant.quick_takes.each { |x| x.destroy }
      expect(restaurant.aggregate_score).to be_a_kind_of(Numeric)
    end

    it "still returns a number if only quick takes exist" do
      third_restaurant.reviews.each { |x| x.destroy }
      expect(restaurant.aggregate_score).to be_a_kind_of(Numeric)
    end
  end

  describe "rest_of_dishes" do

    it "returns the dishes that were not in the top three" do
      expect((restaurant.rest_of_dishes.count + 3)).to eq(restaurant.dishes.count)
    end

  end

  describe "httpify_website" do

    it "returns a linkable version of a pages website" do
      restaurant.website = "www.google.com"
      expect(restaurant.httpify_website).to eq("http://www.google.com")
    end
  end

  describe "httpify_menu_url" do

    it "returns a linkable version of a pages menu url" do
      restaurant.menu_url = "www.google.com"
      expect(restaurant.httpify_menu_url).to eq("http://www.google.com")
    end
  end



end
