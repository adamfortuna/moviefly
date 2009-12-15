class RemovePasswordFromUsers < ActiveRecord::Migration
  def self.up
    remove_column :users, :crypted_password
    remove_column :users, :salt
    remove_column :users, :activation_code
    remove_column :users, :activated_at
  end

  def self.down
  end
end
