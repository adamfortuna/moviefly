class IncreaseRatingsBy10x < ActiveRecord::Migration
  def self.up
    Rating.all.each do |rating|
      rating.update_attribute(:rating, rating.rating*10)
    end
  end

  def self.down
  end
end
