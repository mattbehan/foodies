class CreateRestaurants < ActiveRecord::Migration
  def change
    create_table :restaurants do |t|
      t.string :name, null: false
      t.string :cuisine
      t.string :street_address, null: false
      t.string :city, null: false
      t.string :state, null: false
      t.string :zip, null: false
      t.string :phone_number
      t.string :neighborhood
      t.string :nearest_l
      t.string :website
      t.string :menu_url
      t.integer :price_scale, null: false
      t.string :atmosphere
      t.boolean :delivery
      t.boolean :reservations
      t.integer :vegan_friendliness
      t.boolean :patios
      t.string :dress_code

      t.timestamps null: false
    end
  end
end
