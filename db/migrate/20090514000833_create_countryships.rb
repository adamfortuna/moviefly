class CreateCountryships < ActiveRecord::Migration
  def self.up
    create_table :countryships do |t|
      t.timestamps
      t.belongs_to :movie, :country, :null => false
    end

    add_index :countryships, [:movie_id, :country_id], :unique
    add_index :countryships, :movie_id
    add_index :countryships, :country_id
    
    Movie.all.each do |movie|
      begin
        country = Country.find(movie.country_id)
        movie.countries << country if country
      rescue ActiveRecord::RecordNotFound => e
      end
    end
    
  end

  def self.down
    drop_table :countryships
  end
end