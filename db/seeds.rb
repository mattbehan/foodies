require 'ffaker'

15.times do
  Restaurant.create!(name: FFaker::Company.name, cuisine: FFaker::Food.meat,
                      street_address: FFaker::AddressUS.street_address,
                      city: FFaker::AddressUS.city, state: FFaker::AddressUS.state,
                      zip: FFaker::AddressUS.zip_code, phone_number: FFaker::PhoneNumber.short_phone_number,
                      neighborhood: FFaker::AddressUS.neighborhood, price_scale: rand(1..5),
                      vegan_friendliness: rand(1..5))
end
