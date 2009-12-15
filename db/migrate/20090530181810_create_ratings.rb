class CreateRatings < ActiveRecord::Migration
  def self.up
    create_table :ratings do |t|
      t.timestamps
      t.belongs_to :user, :null => false
      t.belongs_to :movie, :null => false
      t.float :rating, :null => false
    end
    
    add_column :users, :ratings_count, :integer, :default => 0
    add_column :movies, :ratings_count, :integer, :default => 0
    
    Review.find(:all, :conditions => "rating > 0").each do |review|
      Rating.create(:user_id => review.user_id,
                    :movie_id => review.reviewable_id,
                    :rating => review.rating)
    end    
  end

  def self.down
    drop_table :ratings
    remove_column :user, :ratings_count
    remove_column :movies, :ratings_count
  end
end
