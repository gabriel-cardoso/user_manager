class CreateUserManagers < ActiveRecord::Migration
  def change
    create_table :user_managers do |t|
      t.references :user, foreign_key: true
    end
    add_index :user_managers, :user_id, unique: true
  end
end
