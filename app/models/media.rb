class Media < ActiveRecord::Base
  has_many :ownerships
  
  validates_uniqueness_of :name
  validates_presence_of :name
  has_permalink :name
  
  def to_param
    permalink
  end
end