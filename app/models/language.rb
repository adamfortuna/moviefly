class Language < ActiveRecord::Base
  cattr_reader :per_page
  @@per_page = 100

  has_many :languageships, :dependent => :destroy
  has_many :movies, :through => :languageships

  validates_presence_of :name, :abbreviation
  validates_length_of :abbreviation, :is => 2
  validates_uniqueness_of :name, :abbreviation
  has_permalink :name
  
  def self.find_or_create_by_name(name)
    language = self.find_by_name(name)
    return language if language
    puts "Creating language... #{name}"
    return Language.create!({:name => name, :abbreviation => name[0..1].upcase})
  end

  def to_param
    permalink
  end  
end