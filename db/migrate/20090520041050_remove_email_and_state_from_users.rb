class RemoveEmailAndStateFromUsers < ActiveRecord::Migration
  def self.up
    remove_column :users, :email
    remove_column :users, :state
    rename_column :users, :login, :username
  end

  def self.down
    add_column :users, :email, :string
    add_column :users, :state, :string
    rename_column :users, :login, :username
  end
end
