class CreateProfiles < ActiveRecord::Migration
  def change
    create_table :profiles do |t|
    	t.belongs_to :user
      t.string :full_name
      t.string :affiliation
    	t.text :bio, default: "Lover of food"

      t.timestamps null: false
    end
  end
end
