class CreateRoles < ActiveRecord::Migration
  def change
    create_table :roles do |t|

    	t.string :name, null: false, default: "user"
    	t.belongs_to :user, null: false

      t.timestamps null: false
    end
  end
end
