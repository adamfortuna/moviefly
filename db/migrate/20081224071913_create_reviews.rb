class CreateReviews < ActiveRecord::Migration
  def self.up
    create_table :reviews do |t|
      t.timestamps
      t.references :reviewable,  :polymorphic => true
      t.string :title
      t.text :review
      t.float :rating
    end
    
    add_index :reviews, [ :reviewable_id, :reviewable_type]
  end

  def self.down
    drop_table :reviewable
  end
end