require 'capybara/rails'
require 'rails_helper'
require 'spec_helper'
require 'login_helper'

context "visiting the home page" do

  it "contains a featured review" do
    visit "/"
    expect(page.has_content?("Featured Review"))
  end

  
end
