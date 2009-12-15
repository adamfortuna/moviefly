class CreateLists < ActiveRecord::Migration
  def self.up
    create_table :lists do |t|
      t.timestamps
      t.belongs_to :user
      t.string :title
      t.text :conditions
      t.string :order
    end
  end

  def self.down
    drop_table :lists
  end
end
