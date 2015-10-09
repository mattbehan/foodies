class CreateQuickTakes < ActiveRecord::Migration
  def change
    create_table :quick_takes do |t|
      t.integer :user_id
      t.integer :restaurant_id
      t.integer :rating

      t.timestamps
    end
  end
end
