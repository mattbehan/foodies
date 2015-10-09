class CreateProfiles < ActiveRecord::Migration
  def change
    create_table :profiles do |t|
    	t.belongs_to :user, index: true
    	t.string :bio

      t.timestamps null: false
    end
  end
end
