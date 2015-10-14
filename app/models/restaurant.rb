require 'net/http'

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
  # validates_format_of :state, with: /[A-Z]{2}/

  attr_accessor   :score

  def self.search(query, lat_data, long_data)

    if query
      all_results = find_exact_matches(query) + find_keyword_matches(query) + find_fuzzy_matches(query)
      p "WITHIN search ___________"
      all_results = all_results.uniq
      p lat_data
      p long_data
      if lat_data && long_data
        add_distance_to_collection( lat_data, long_data, all_results )
      else
        all_results
      end
    else
      where(:all)
    end
  end

  def self.create_url_request lat, long, restaurant
    request = "https://maps.googleapis.com/maps/distancematrix/json?origins="
    request += "#{lat},#{long}"
    request += "&destinations="
    request += "#{restaurant.street_address}"
    request += "+#{restaurant.city}" 
    request += "+#{restaurant.state}"
    request += "+#{restaurant.zip}"
    request += "&mode=walking/"
    request.gsub(/\s/, "+")

  end

  def self.add_distance_to_collection lat, long, results
    results.map {|result| result.add_distance_to_result(lat, long, result)}
  end

  def add_distance_to_result lat, long, result
    # result = Net::HTTP.get(URI.parse(Restaurant.create_url_request(lat, long, result)))
    # p result
    p "                                                                                          "


    url = Restaurant.create_url_request(lat, long, result)
    uri = URI.parse(url)
    request = Net::HTTP::Get.new(uri.request_uri)
    response = Net::HTTP.start(uri.host, uri.port) {|http|
      http.request(request)
    }
    p response


    # Get.new 
    # start takes the host, the port, and an optional block. the block will actually make the request which returns a response and can then be read

    # req = Net::HTTP::Get.new(url.to_s)
    # response = Net::HTTP.start(url.host, url.port) {|http|
    #   http.request(req)
    # }
    # p "RESPONSE"
    # p response
    # response = JSON.parse(response)
    # puts "response: #{response}"
    puts "_____________________________" 
    # return [result, response]
  end

  def self.filter(type,query)
    restaurants = Restaurant.search(query)
    restaurants.each do |restaurant|
      restaurant.score = restaurant.aggregate_score
    end

    case type
    when "cuisine"
      return restaurants.sort_by(&:cuisine)
    when "name"
      return restaurants.sort_by(&:name)
    when "neighborhood"
      return restaurants.sort_by(&:neighborhood)
    when "score"
      return restaurants.select {|restaurant| restaurant.score != "N/A" }.sort_by{|restaurant| -restaurant.score}
    end

  end

  def top_three_dishes
    self.specialties.sort_by { |dish| dish.vote_count }.reverse[0..2] || []
  end

  def rest_of_dishes
    specialties.sort_by { |dish| dish.vote_count }.reverse[3..-1] || []
  end


  def aggregate_score
    if self.reviews.any?
      if self.quick_takes.any?
        qt_avg = mean(self.quick_takes.map { |qt| qt.rating })
        review_avg = mean(self.reviews.map { |review| review.rating })
        weighted_mean(review_avg, 0.75) + weighted_mean(qt_avg, 0.25)
      else
        mean(self.reviews.map { |review| review.rating })
      end
    else
      "N/A"
    end
  end

  def tags_for_display
    tag_names = []
    tags.each do |tag|
      tag_names << tag.name.capitalize
    end
    tag_names.join(", ")
  end

  private

  def mean(numbers)
    numbers.inject(:+) / numbers.length
  end

  def weighted_mean(number, decimal)
    number * decimal
  end

  def self.find_exact_matches(full_query_string)
    query_input =
    [(
      [('lower(name) LIKE ?')] +
      [('lower(cuisine) LIKE ?')] +
      [('lower(neighborhood) LIKE ?')] +
      [('lower(atmosphere) LIKE ?')]
    ).join(' OR ')] +
    ["#{full_query_string.downcase}"]*4

    where(query_input)
  end

  def self.find_keyword_matches(query)
    query_keywords = query.split.select do |word|
      word.downcase == "cheap" || word.downcase == "vegan" || word.downcase == "vegetarian"
    end

    if query_keywords.include?("vegan") || query_keywords.include?("vegetarian")
      where('vegan_friendliness >= 4')
    elsif query_keywords.include? "cheap"
      where('price_scale <= 2')
    else
      Array.new
    end
  end

  def self.find_fuzzy_matches(query)
    query_length = query.split.length

    if query_length != 0
      query_input =
      [([(['lower(name) LIKE ?'] * query_length).join(' AND ')] +
        [(['lower(cuisine) LIKE ?'] * query_length).join(' AND ')] +
        [(['lower(neighborhood) LIKE ?'] * query_length).join(' AND ')]).join(' OR ')] +
        query.split.map { |name| "%#{name.downcase}%" }*3
        p query_input
      where(query_input)
    else
      Array.new
    end
  end

end
