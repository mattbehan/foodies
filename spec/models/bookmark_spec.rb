require 'spec_helper'
require 'rspec/rails'
require 'capybara/rails'
require 'shoulda-matchers'

describe Bookmark do
  it { should belong_to :bookmarked_restaurant }
  it { should belong_to :bookmarker }
  it { should validate_presence_of :bookmarker_id }
  it { should validate_presence_of :bookmarked_restaurant }
end
