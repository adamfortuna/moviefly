class RemoveRatingFromReviews < ActiveRecord::Migration
  def self.up
    remove_column :reviews, :rating
  end

  def self.down
    add_column :reviews, :rating
  end
end
