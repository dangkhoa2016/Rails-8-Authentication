class AddUserFieldIndexes < ActiveRecord::Migration[8.0]
  def change
    add_index :users, :first_name
    add_index :users, :last_name
  end
end
