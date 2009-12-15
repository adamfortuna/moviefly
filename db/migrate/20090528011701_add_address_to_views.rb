class AddAddressToViews < ActiveRecord::Migration
  def self.up
    add_column :views, :address, :string
  end

  def self.down
    remove_column :views, :address
  end
end
