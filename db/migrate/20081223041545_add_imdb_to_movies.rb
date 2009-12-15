class AddImdbToMovies < ActiveRecord::Migration
  def self.up
    add_column :movies, :imdb_id, :string
  end

  def self.down
    drop_column :imdb_id, :movies
  end
end
