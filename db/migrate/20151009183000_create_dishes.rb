class CreateDishes < ActiveRecord::Migration
  def change
    create_table :dishes do |t|
      t.string :name, null: false

      t.timestamps null: false
    end
    add_index :dishes, :name, unique: true
  end
end
