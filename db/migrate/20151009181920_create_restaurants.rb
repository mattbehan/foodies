class CreateRestaurants < ActiveRecord::Migration
  def change
    create_table :restaurants do |t|
      t.string :name
      t.string :cuisine
      t.string :street_address
      t.string :city
      t.string :state
      t.string :zip
      t.string :phone_number
      t.string :neighborhood
      t.string :nearest_l
      t.string :website
      t.string :menu_url
      t.integer :price_scale
      t.string :atmosphere
      t.boolean :delivery
      t.boolean :reservations
      t.integer :vegan_friendliness
      t.boolean :patios
      t.string :dress_code

      t.timestamps
    end
  end
end
