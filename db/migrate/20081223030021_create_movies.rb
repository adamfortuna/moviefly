class CreateMovies < ActiveRecord::Migration
  def self.up
    create_table :movies do |t|
      t.string :name, :alias
      t.belongs_to :language, :null => false
      t.belongs_to :country, :null => false
      t.integer :year
      t.decimal :rating

      t.timestamps
    end
  end

  def self.down
    drop_table :movies
  end
end
