class Dish < ActiveRecord::Base
  has_many :specialties
  has_many :restaurants, through: :specialties

  validates :name, presence: true

end
