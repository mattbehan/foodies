class Restaurant < ActiveRecord::Base
  has_many :taggings
  has_many :tags, through: :taggings
  has_many :reviews
  has_many :reviewers, through: :reviews
  has_many :bookmarks, foreign_key: "bookmarked_restaurant_id"
  has_many :bookmarkers, through: :bookmarks
  has_many :quick_takes
  has_many :raters, through: :quick_takes
  has_many :specialties
  has_many :dishes, through: :specialties
  has_many :visits, foreign_key: "visited_restaurant_id"
  has_many :visitors, through: :visits

  validates :name, :street_address, :city, :state, :zip, :price_scale, presence: true
  validates_inclusion_of :price_scale, :in => 1..5
  validates_inclusion_of :vegan_friendliness, :in => 1..5
  validates_format_of :zip, with: /\d{5}/

  def self.search(query)
    # where(:title, query) -> This would return an exact match of the query
    # where("lower(name) LIKE ?", "%#{query.downcase}%")

    if query
      query_length = query.split.length
      query_input = [(['lower(name) LIKE ?'] * query_length).join(' AND ')] + query.split.map { |name| "%#{name.downcase}%" }
      where(query_input)
    else
      where(:all)
    end
  end

  def top_three_dishes
    dishes = self.specialties.sort_by { |dish| dish.vote_count }[-3..-1].reverse
  end

end
