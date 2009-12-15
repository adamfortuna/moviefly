class Country < ActiveRecord::Base  
  cattr_reader :per_page
  @@per_page = 100
  
  has_many :countryships, :dependent => :destroy
  has_many :movies, :through => :countryships
  
  validates_presence_of :name, :abbreviation
  validates_length_of :abbreviation, :is => 2
  validates_uniqueness_of :name, :abbreviation
  has_permalink :name
  
  def self.find_or_create_by_name(name)
    country = self.find_by_name(name)
    return country if country
    puts "Creating country... #{name}"
    return Country.create!({:name => name, :abbreviation => name[0..1].upcase})
  end
  
  def to_param
    permalink
  end
end