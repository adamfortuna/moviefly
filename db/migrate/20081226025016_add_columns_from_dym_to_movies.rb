class AddColumnsFromDymToMovies < ActiveRecord::Migration
  def self.up
    add_column :movies, :imdb_rating, :float
    add_column :movies, :runtime, :integer
    
  end

  def self.down
    remove_column :movies, :runtime
    remove_column :movies, :imdb_rating
  end
end
