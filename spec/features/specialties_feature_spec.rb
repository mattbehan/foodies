require 'capybara/rails'
require 'rails_helper'
require 'spec_helper'
require 'login_helper'

include LoginHelper

describe "adding a specialty" do

  it "provides a place to log in if the user is not logged in" do
    visit "/restaurants/1"
    expect(page.has_content?("You're not logged in."))
  end

  it "allows a user to add a comment if the user is logged in" do
    login
    visit "/restaurants/1"
    first(:xpath, "//a[@href='/']").click
    expect(page.has_css?('.new-specialty-text'))
  end

  
end
