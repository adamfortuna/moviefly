class AddRatingStepToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :rating_step, :float, :default => 5
  end

  def self.down
    remove_column :users, :rating_step
  end
end
