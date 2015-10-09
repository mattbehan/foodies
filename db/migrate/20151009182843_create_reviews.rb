class CreateReviews < ActiveRecord::Migration
  def change
    create_table :reviews do |t|
      t.string :title
      t.text :content
      t.integer :rating
      t.integer :restaurant_id
      t.integer :reviewer_id

      t.timestamps
    end
  end
end
