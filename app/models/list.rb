class List < ActiveRecord::Base
  belongs_to :user
  validates_presence_of :title, :conditions  
  serialize :conditions, Array

  def and_conditions
    And.new(conditions)
  end
  
  def finder_order
    order || "name asc"
  end
  
  def movies
    Movie.find(:all, and_conditions.finder_options, :order => finder_order)
  end
end