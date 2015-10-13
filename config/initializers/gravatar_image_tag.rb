food_photos = [
  "app/public/images/apples_and_bananas.jpg",
  "app/public/images/bento_box.jpg",
  "app/public/images/breakfast_croissants.jpg",
  "app/public/images/chocolate_doughnut.jpg",
  "app/public/images/dessert.jpg",
  "app/public/images/fast_food_meal.jpg",
  "app/public/images/fried_breakfast.jpg",
  "app/public/images/pizza.jpg",
  "app/public/images/ramen.jpg",
  "app/public/images/strawberries_halved.jpg"
]

GravatarImageTag.configure do |config|
  # config.default_image = image_tag("ramen.jpg")
  config.filetype = nil
  config.include_size_attributes = true
  config.rating = nil
  config.size = 80
  config.secure = false
end
