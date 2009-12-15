class AddNotesToViewships < ActiveRecord::Migration
  def self.up
    add_column :viewships, :notes, :text
    
    View.find(:all, :conditions => ['notes IS NOT NULL AND notes != ""']).each do |view|
      view.viewships.each do |viewship|
        if view.creator?(viewship.viewable)
          viewship.update_attribute(:notes, view.notes)
        end
      end
    end
    
    remove_column :views, :notes
  end

  def self.down
    add_column :views, :notes, :text
    
    Viewship.find(:all, :conditions => ['notes IS NOT NULL AND notes != ""']).each do |viewship|
      if viewship.view.creator?(viewship.viewable)
        viewship.view.update_attribute(:notes, viewship.notes)
      end
    end
    
    remove_column :viewships, :notes
  end
end
