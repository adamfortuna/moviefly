class View < ActiveRecord::Base
  extend ActiveSupport::Memoizable
  belongs_to :movie
  belongs_to :user
  
  has_many :viewships
  
  validates_presence_of :movie, :user
  validates_associated :viewships
  validates_date :on, :before => [Proc.new { 1.day.from_now}], :after => [Proc.new {100.years.ago}], :allow_nil => true

  attr_accessor :notes
  
  after_create :create_viewship_for_creator
  def create_viewship_for_creator
    viewships << Viewship.new({:user => user, :confirmed => true, :movie => movie })
  end
  
  
  def new_viewship_attributes=(viewship_attributes)
    viewship_attributes.each do |attributes|
      viewships.build(attributes.merge(:movie => movie))
    end
  end

  def existing_viewship_attributes=(viewship_attributes)
    viewships.reject(&:new_record?).each do |viewship|
      attributes = viewship_attributes[viewship.id.to_s]
      if attributes
        viewship.attributes = attributes.merge(:view_id => self.id, :movie => movie)
      else
        viewship.destroy if viewship.user_id != self.user_id
      end
    end
  end

  after_update :save_viewships
  def save_viewships
    viewships.each do |viewship|
      viewship.save(false)
    end
  end
  
  def creator?(_user)
    user == _user
  end
  
  def viewers
    viewships.find(:all, :select=>"viewable_id", :conditions => ["viewable_type='User'"]).collect(&:viewable_id)
  end
  memoize :viewers
  
  def has_attendee(user)
    viewers.include?(user.id)
  end
  
  def viewship_for(user)
    viewships.find(:first, :conditions => ["viewable_type='User' AND viewable_id=?", user.id])
  end
end