class AddPermalinksToSupporting < ActiveRecord::Migration
  def self.up
    add_column :languages, :permalink, :string
    add_column :countries, :permalink, :string
    add_column :medias, :permalink, :string
  end

  def self.down
    remove_column :languages, :permalink
    remove_column :countries, :permalink
    remove_column :medias, :permalink
  end
end
