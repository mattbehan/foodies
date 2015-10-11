require 'ffaker'

15.times do
  Restaurant.create!(name: FFaker::Company.name, cuisine: FFaker::Food.meat,
                      street_address: FFaker::AddressUS.street_address,
                      city: FFaker::AddressUS.city, state: FFaker::AddressUS.state,
                      zip: FFaker::AddressUS.zip_code, phone_number: FFaker::PhoneNumber.short_phone_number,
                      neighborhood: FFaker::AddressUS.neighborhood, nearest_l: FFaker::AddressUS.neighborhood,
                      website: FFaker::Internet.http_url, menu_url: FFaker::Internet.http_url,
                      price_scale: rand(1..5), atmosphere: FFaker::HipsterIpsum.word, delivery: true,
                      reservations: false, vegan_friendliness: rand(1..5), patios: false,
                      dress_code: "Hipster")
end

50.times do
  review = Review.create!(title: FFaker::Company.bs, content: FFaker::HipsterIpsum.paragraphs,
                  rating: rand(1..5), restaurant_id: rand(1..15), reviewer_id: rand(1..100))
  rand(1..8).times do
    Comment.create!(content: FFaker::HipsterIpsum.sentence, review_id: review.id, user_id: rand(1..100))
  end
end

20.times do
  Article.create!(title: FFaker::Company.bs, content: FFaker::HipsterIpsum.paragraphs,
                  author_id: rand(1..100))
end

while User.all.length <= 100
  user = User.create(email: FFaker::Internet.email, username: FFaker::Internet.user_name, password: "password")
  profile = Profile.create(bio: FFaker::BaconIpsum.words(50), affiliation: FFaker::Company.bs, full_name: FFaker::Name.name, user_id: user.id )
end

# Dishes
10.times do
  Dish.create!(name: FFaker::Education.school.concat(" "+FFaker::Food.meat))
end

# Specialties
100.times do
  Specialty.create!(restaurant_id: rand(1..15),dish_id: rand(1..10))
end

# Votes
comments = Comment.all
600.times do
  Vote.create!(value: [1,1,1,-1,-1].sample, votable_type: "Review", votable_id: rand(1..50),user_id: rand(1..100))
  Vote.create!(value: [1,1,1,-1,-1].sample, votable_type: "Specialty", votable_id: rand(1..100),user_id: rand(1..100))
  Vote.create!(value: [1,1,1,-1,-1].sample, votable_type: "Comment", votable_id: comments.sample.id, user_id: rand(1..100))
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
