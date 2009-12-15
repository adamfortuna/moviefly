class AddCounterCaches < ActiveRecord::Migration
  def self.up
    add_column :viewships, :movie_id, :integer
    
    add_column :users, :reviews_count, :integer, :default => 0
    add_column :movies, :reviews_count, :integer, :default => 0
    
    add_column :users, :ownerships_count, :integer, :default => 0
    add_column :movies, :ownerships_count, :integer, :default => 0
    
    add_column :users, :movieships_count, :integer, :default => 0
    add_column :movies, :movieships_count, :integer, :default => 0
    
    add_column :medias, :ownerships_count, :integer, :default => 0
    
    add_column :users,  :viewships_count, :integer, :default => 0    
    add_column :movies, :viewships_count, :integer, :default => 0    
  end

  def self.down
    remove_column :viewships, :movie_id
    
    remove_column :users, :reviews_count
    remove_column :users, :ownerships_count
    remove_column :users, :movieships_count
    remove_column :users, :viewships_count
    
    remove_column :movies, :movieships_count
    remove_column :movies, :reviews_count
    remove_column :movies, :ownerships_count
    remove_column :movies, :viewships_count
    
    remove_column :medias, :ownerships_count
  end
end
