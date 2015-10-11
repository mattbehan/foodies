require 'capybara/rails'
require 'rails_helper'

describe "a restaurant page" do

  it "has a title of the restaurant" do
    visit "/restaurants/1"
    expect{page.first("h1").should_not be(nil)}
  end

  it "successfully changes the vote value of a review" do
    visit "/users/sign_in"
    fill_in 'Email', :with => User.first.email
    fill_in 'Password', :with => 'password'
    click_button 'Log in'

    visit "/restaurants/1"
    vote_total = page.first('span').value
    p vote_total
    first(".upvote-button").click
    expect{page.first('span').should_not be(vote_total)}
  end
end

describe "the log in process" do

  it "successfully logs in a valid user and redirects to their profile" do
    visit "/users/sign_in"
    fill_in 'Email', :with => User.first.email
    fill_in 'Password', :with => 'password'
    click_button 'Log in'
    expect{page.has_content?('profile page')}
  end

  it "changes the login url in the navbar to the logout url" do
    expect{page.has_content?('Login')}
    visit "/users/sign_in"
    fill_in 'Email', :with => User.first.email
    fill_in 'Password', :with => 'password'
    click_button 'Log in'
    expect{page.has_content?('Logout')}
  end


end
