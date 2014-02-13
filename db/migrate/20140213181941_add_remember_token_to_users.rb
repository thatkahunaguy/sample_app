class AddRememberTokenToUsers < ActiveRecord::Migration
  def change
      add_column :users, :remember_token, :string
      # make it an index since we'll find by it.  Assuming
      # secure generation gives negligible probability of non-unique
      add_index :users, :remember_token
  end
end
