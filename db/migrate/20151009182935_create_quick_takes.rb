class CreateQuickTakes < ActiveRecord::Migration
  def change
    create_table :quick_takes do |t|
      t.integer :rater_id, null: false
      t.integer :restaurant_id, null: false
      t.integer :rating, null: false

      t.timestamps null: false
    end
  end
end
