class AddBoxartToMovies < ActiveRecord::Migration
  def self.up
    add_column :movies, :boxart, :string, :null => true
  end

  def self.down
    remove_column :movies, :boxart
  end
end
