require 'ffaker'

15.times do
  Restaurant.create!(name: FFaker::Company.name, cuisine: FFaker::Food.meat,
                      street_address: FFaker::AddressUS.street_address,
                      city: FFaker::AddressUS.city, state: FFaker::AddressUS.state,
                      zip: FFaker::AddressUS.zip_code, phone_number: FFaker::PhoneNumber.short_phone_number,
                      neighborhood: FFaker::AddressUS.neighborhood, price_scale: rand(1..5),
                      vegan_friendliness: rand(1..5))
end

50.times do
  Review.create!(title: FFaker::Company.bs, content: FFaker::HipsterIpsum.paragraphs,
                  rating: rand(1..5), restaurant_id: rand(1..15), reviewer_id: rand(1..100))
end

100.times do
  User.create!(email: FFaker::Internet.email, password: FFaker::Internet.password)
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
  Vote.create!(value: 1,votable_type: "Specialty", votable_id: rand(1..100),user_id: counter)
  counter += 1
end
