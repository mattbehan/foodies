require 'capybara/rails'
require 'rails_helper'
require 'spec_helper'
require 'login_helper'

include LoginHelper

describe "a restaurant page" do

  it "has a title of the restaurant" do
    visit "/restaurants/1"
    expect{page.first("h1").should_not be(nil)}
  end

  it "successfully changes the vote value of a review on upvote" do
    login

    visit "/restaurants/1"
    vote_total = page.first('.total').text
    first(".upvote-button").click
    expect{page.first('.total').should_not eq(vote_total)}
  end

  it "successfully changes the vote value of a review on downvote" do
    login

    visit "/restaurants/1"
    vote_total = page.first('.total').text
    first('.downvote-button').click
    expect{page.first('.total').should_not eq(vote_total)}
  end
end

describe "the log in process" do

  it "successfully logs in a valid user and redirects to their profile" do
    login

    expect{page.has_content?('profile page')}
  end

  it "changes the login url in the navbar to the logout url" do
    expect{page.has_content?('Login')}
    login
    expect{page.has_content?('Logout')}
  end
end
