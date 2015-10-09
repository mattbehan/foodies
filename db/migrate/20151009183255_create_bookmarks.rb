class CreateBookmarks < ActiveRecord::Migration
  def change
    create_table :bookmarks do |t|
      t.integer :bookmarker_id, null: false
      t.integer :bookmarked_restaurant_id, null: false

      t.timestamps null: false
    end
  end
end
