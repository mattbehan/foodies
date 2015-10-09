class CreateBookmarks < ActiveRecord::Migration
  def change
    create_table :bookmarks do |t|
      t.integer :bookmarker_id
      t.integer :bookmarked_restaurant_id

      t.timestamps
    end
  end
end
