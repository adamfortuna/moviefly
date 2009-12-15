class CreateFriendships < ActiveRecord::Migration
  def self.up
    create_table :friendships do |t|
      t.timestamps
      t.belongs_to :user, :null => false
      t.integer :friend_id, :null => false
    end
  end

  def self.down
    drop_table :friendships
  end
end
