class CreateMovieships < ActiveRecord::Migration
  def self.up
    create_table :movieships do |t|
      t.timestamps
      t.belongs_to :movie, :null => false
      t.belongs_to :user, :null => false
    end
  end

  def self.down
    drop_table :movieships
  end
end
