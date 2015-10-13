module SortResultsHelper
  def sort_restaurants(restaurants,type)
    restaurants.each do |restaurant|
      restaurant.score = restaurant.aggregate_score
    end

    case type
    when "cuisine"
      filtered_restaurants = restaurants.all.to_a.sort_by(&:cuisine)
    when "name"
      filtered_restaurants = restaurants.all.to_a.sort_by(&:name)
    when "neighborhood"
      filtered_restaurants = restaurants.all.to_a.sort_by(&:neighborhood)
    when "score"
      filtered_restaurants = restaurants.all.to_a.sort_by(&:score)
    end

    return filtered_restaurants
  end
end