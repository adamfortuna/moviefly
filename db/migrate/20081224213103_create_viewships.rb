class CreateViewships < ActiveRecord::Migration
  def self.up
    create_table :viewships do |t|
      t.timestamps
      t.belongs_to :view, :null => false
      t.belongs_to :user, :null => false
      t.boolean :confirmed, :default => false
    end
  end

  def self.down
    drop_table :viewships
  end
end
