class CreateLanguageships < ActiveRecord::Migration
  def self.up
    create_table :languageships do |t|
      t.timestamps
      t.belongs_to :movie, :language, :null => false
    end

    add_index :languageships, [:movie_id, :language_id], :unique
    add_index :languageships, :movie_id
    add_index :languageships, :language_id
    
    Movie.all.each do |movie|
      begin
        language = Language.find(movie.language_id)
        movie.languages << language if language
      rescue ActiveRecord::RecordNotFound => e
      end
    end
  end

  def self.down
    drop_table :languageships
  end
end