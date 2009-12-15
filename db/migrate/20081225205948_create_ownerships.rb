class CreateOwnerships < ActiveRecord::Migration
  def self.up
    create_table :ownerships do |t|
      t.timestamps
      t.belongs_to :movie, :null => false
      t.belongs_to :user, :null => false
      t.belongs_to :media, :null => false
      t.integer :count, :default => 1
      t.string :notes
    end
  end

  def self.down
    drop_table :ownerships
  end
end