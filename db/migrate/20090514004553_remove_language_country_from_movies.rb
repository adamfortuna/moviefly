class RemoveLanguageCountryFromMovies < ActiveRecord::Migration
  def self.up
    remove_column :movies, :country_id
    remove_column :movies, :language_id
  end

  def self.down
    add_column :movies, :country_id, :integer
    add_column :movies, :language_id, :integer
  end
end
