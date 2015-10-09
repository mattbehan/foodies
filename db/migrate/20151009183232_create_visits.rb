class CreateVisits < ActiveRecord::Migration
  def change
    create_table :visits do |t|
      t.integer :visited_restaurant_id, null: false
      t.integer :visitor_id, null: false

      t.timestamps null: false
    end
  end
end
