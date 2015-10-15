require 'spec_helper'
require 'rspec/rails'
require 'capybara/rails'
require 'shoulda-matchers'

describe Dish do
  it { should have_many :specialties }
  it { should have_many :restaurants }
  it { should validate_presence_of :name }
end
