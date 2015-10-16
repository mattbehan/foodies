require 'capybara/rails'
require 'rails_helper'
require 'spec_helper'
require 'login_helper'

include LoginHelper
# include WaitForAjax

describe "making a comment" do

  it "has a link to show comments" do
    visit "/restaurants/1"
    expect(page.has_css?(".comment-toggle"))
  end

  it "displays comments when clicked" do
    visit "/restaurants/1"
    first(:xpath, "//a[@href='/']").click
    Capybara.default_max_wait_time
    expect(page.has_content?("Comments"))
  end
end
