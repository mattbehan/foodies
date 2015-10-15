require 'capybara/rails'
require 'rails_helper'
require 'spec_helper'
require 'login_helper'

include LoginHelper

context "logging in" do

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
