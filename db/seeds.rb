require 'ffaker'

# neighborhoods = ["Rogers Park","West Ridge","Uptown","Lincoln Square","Edison Park","Norwood Park","Jefferson Park","Forest Glen","North Park","Albany Park","O'Hare","Edgewater","North Center","Lakeview","Lincoln Park","Avondale","Logan Square","Portage Park","Irving Park","Dunning","Montclare","Belmont Cragin","Hermosa","Near North Side","Loop","Near South Side","Humboldt Park","West Town","Austin","West Garfield Park","East Garfield Park","Near West Side","North Lawndale","South Lawndale","Lower West Side","Garfield Ridge","Archer Heights","Brighton Park","McKinley Park","New City","West Elsdon","Gage Park","Clearing","West Lawn","Chicago Lawn","West Englewood","Englewood","Armour Square","Douglas","Oakland","Fuller Park","Grand Boulevard","Kenwood","Washington Park","Hyde Park","Woodlawn","South Shore","Bridgeport","Greater Grand Crossing","Ashburn","Auburn Gresham","Beverly","Washington Heights","Mount Greenwood","Morgan Park","Chatham","Avalon Park","South Chicago","Burnside","Calumet Heights","Roseland","Pullman","South Deering","East Side","West Pullman","Riverdale","Hegewisch"]
neighborhoods = ["Albany Park","Andersonville","Archer Heights","Ashburn","Aubrun Gresham","Austin","Avalon Park","Avondale","Back of the Yards","Belmont Cragin","Beverly","Boystown","Bridgeport","Brighton Park","Bronzeville","Burnside","Calumet Heights","Chatham","Chicago Lawn","Chinatown","Dunning","East Side","Edgewater","Edison Park","Engelwood","Forest Glen","Fullerton Park","Gage Park","Galewood","Garfield Park","Gold Coast","Goose Island","Grand Crossing","Hegewisch","Hermosa","Humboldt Park","Hyde Park","Irving Park","Jefferson Park","Kenwood","Lakeview","Lincoln Park","Lincoln Sqaure","Little Italy and University Village","Little Village","Logan Square","Loop","Rush and Divison","McKinley Park","Midway, Garfiel Ridge and Clearing","Montclare","Morgan Park","Mount Greenwood","North Center","North Lawndale","North Park","Norwood Park","O'Hare","Old Town","Pilsen","Portage Park","Pullman","River North","Riverdale","Rogers Park","Roscoe Village","Roseland","South Chicago","South Deering","South Loop","South Shore","Streeterville","United Center","Uptown","Washington Heights","Washington Park","West Elsdon","West Lawn","West Loop","West Pullman","West Ridge","West Town","Bucktown","Woodlawn","Wrigleyville"]
15.times do
  Restaurant.create!(name: FFaker::Company.name, cuisine: FFaker::Food.meat,
                      street_address: FFaker::AddressUS.street_address,
                      city: FFaker::AddressUS.city, state: FFaker::AddressUS.state,
                      zip: FFaker::AddressUS.zip_code, phone_number: FFaker::PhoneNumber.short_phone_number,
                      neighborhood: neighborhoods.sample, price_scale: rand(1..5),
                      vegan_friendliness: rand(1..5))
end

50.times do
  Review.create!(title: FFaker::Company.bs, content: FFaker::HipsterIpsum.paragraphs,
                  rating: rand(1..5), restaurant_id: rand(1..15), reviewer_id: rand(1..100))
end

100.times do
  User.create(email: FFaker::Internet.email, username: FFaker::Internet.user_name, password: "password")
end

# Dishes
10.times do
  Dish.create!(name: FFaker::Education.school.concat(" "+FFaker::Food.meat))
end

# Specialties
100.times do
  Specialty.create!(restaurant_id: rand(1..15),dish_id: rand(1..10))
end

counter = 1
600.times do
  Vote.create!(value: 1,votable_type: "Specialty", votable_id: rand(1..100),user_id: rand(1..100))
  counter += 1
end

users = User.all
restaurants = Restaurant.all

# User follows, visited restaurants, bookmarked restaurants, and quick takes
users.each_with_index do |user, index|
  potential_followed = (1..100).to_a - [index+1]
  chosen_followed_ids = potential_followed.sample(rand(5..15))
  chosen_followed_ids.each do |chosen_followed_id|
    Following.create!(follower_id: user.id, followed_user_id: chosen_followed_id)
  end
end

users.each do |user|
  shuffled_restaurants = restaurants.shuffle

  visited_restaurants = shuffled_restaurants[0..2]
  visited_restaurants.each do |visited_restaurant|
    user.visited_restaurants << visited_restaurant
  end

  user.visited_restaurants.each do |eatery|
    QuickTake.create!(rater_id: user.id, restaurant_id: eatery.id, rating: rand(1..5))
  end

  bookmarked_restaurants = shuffled_restaurants[3..5]
  bookmarked_restaurants.each do |bookmarked_restaurant|
    user.bookmarked_restaurants << bookmarked_restaurant
  end
end
