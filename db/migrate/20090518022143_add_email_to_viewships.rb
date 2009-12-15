class AddEmailToViewships < ActiveRecord::Migration
  def self.up
    rename_column :viewships, :user_id, :viewable_id
    add_column :viewships, :viewable_type, :string
    create_table :emails do |t|
      t.timestamps
      t.integer :user_id, :null => true
      t.string :email, :name, :claim_code
      t.boolean :confirmed, :default => false
    end
    
    Viewship.update_all "viewable_type='User'"
    
    User.all.each do |user|
      Email.create({ :user_id => user.id, :email => user.email, :confirmed => true })
    end
  end

  def self.down
    rename_column :viewships, :viewable_id, :user_id
    remove_column :viewships, :viewable_id
    drop_table :emails
  end
end
