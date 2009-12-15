class CreateMedias < ActiveRecord::Migration
  def self.up
    create_table :medias do |t|
      t.timestamps
      t.string :name
    end
    
  end

  def self.down
    drop_table :medias
  end
end
