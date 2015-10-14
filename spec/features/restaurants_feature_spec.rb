require 'capybara/rails'
require 'rails_helper'
require 'spec_helper'
require 'login_helper'

include LoginHelper

def wait_for_ajax
  Timeout.timeout(Capybara.default_wait_time) do
    active = page.evaluate_script('jQuery.active')
    until active == 0
      active = page.evaluate_script('jQuery.active')
    end
  end
end

describe "a restaurant page" do

  it "has a title of the restaurant" do
    visit "/restaurants/1"
    expect{page.first("h1").should_not be(nil)}
  end
end
#
#   it "successfully changes the vote value of a review on upvote" do
#     login
#
#     visit "/restaurants/1"
#     vote_total = page.first('.total').text
#     first(".upvote-button").click
#     expect{page.first('.total').should_not eq(vote_total)}
#   end
#
#   it "successfully changes the vote value of a review on downvote" do
#     login
#
#     visit "/restaurants/1"
#     vote_total = page.first('.total').text
#     first('.downvote-button').click
#     expect{page.first('.total').should_not eq(vote_total)}
#   end
# end

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
  #
  describe "doing a quick take" do
    it "creates a quick take when logged in" do
      login
      visit "/restaurants/1"
      click_link("Rate it.")
      wait_for_ajax
      click_button("Create Quick Take")
      wait_for_ajax
      expect{page.has_content?("Great! Thanks for rating.")}
    end
  end
end
