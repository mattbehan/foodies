require 'capybara/rails'
require 'rails_helper'
require 'spec_helper'
require 'login_helper'


# context "searching for a restaurant" do
#   it "successfully retrieves information about a restaurant" do
#     visit "/"
#     fill_in "search", with: Restaurant.first.name
#     expect{page.has_content?(Restaurant.first.name)}
#   end
#
#   it "contains a link to the found restaurant" do
#     visit "/"
#     fill_in "search", with: Restaurant.first.name
#     first('a').click
#     expect{page.has_content?("Restaurant Info")}
#   end
# end
