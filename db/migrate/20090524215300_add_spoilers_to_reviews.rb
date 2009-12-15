class AddSpoilersToReviews < ActiveRecord::Migration
  def self.up
    add_column :reviews, :has_spoilers, :boolean, :default => false
  end

  def self.down
    remove_column :reviews, :has_spoilers
  end
end
