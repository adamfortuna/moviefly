class CreateViews < ActiveRecord::Migration
  def self.up
    create_table :views do |t|
      t.timestamps
      t.belongs_to :user, :null => false
      t.belongs_to :movie, :null => false
      t.datetime :on
      t.string :location
      t.text :notes
    end
  end

  def self.down
    drop_table :views
  end
end
