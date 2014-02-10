class AddIndexToUsersEmail < ActiveRecord::Migration
  def change
  # change the dbase so the email is the unique database index
    add_index :users, :email, unique: true
  end
end
