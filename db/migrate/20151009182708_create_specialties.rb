class CreateSpecialties < ActiveRecord::Migration
  def change
    create_table :specialties do |t|
      t.integer :restaurant_id, null: false
      t.integer :dish_id, null: false

      t.timestamps null: false
    end
  end
end
