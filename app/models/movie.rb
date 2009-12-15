require 'rio'

class Movie < ActiveRecord::Base
  cattr_reader :per_page
  @@per_page = 25

  acts_as_taggable
  has_permalink :name
  
  has_many :reviews, :as => :reviewable, :dependent => :destroy
  has_many :views
  has_many :viewships
  has_many :ownerships
  has_many :movieships
  
  has_many :languageships, :dependent => :destroy
  has_many :languages, :through => :languageships
  
  has_many :countryships, :dependent => :destroy
  has_many :countries, :through => :countryships

  validates_presence_of :name, :year
  validates_numericality_of :year, :greater_than => 1890, :less_than => (Time.now.year+10)
  validates_uniqueness_of :name
  validates_uniqueness_of :imdb_id, :message => "has already been imported."
  validates_length_of :imdb_id, :is => 9
  
  define_index do
    indexes :name, :sortable => true
    indexes :alias
    
    has created_at, updated_at, year, rating, imdb_rating, runtime
  end

  def to_param
    permalink
  end
  
  def title
    name
  end
  
  def incomplete?
    runtime.nil? || imdb_rating.nil? || year.nil? || tag_list.length==0 || boxart.nil?
  end
  
  def has_boxart?
   File.exists?(boxart_path)
  end

  def boxart_path
    File.expand_path(File.dirname(__FILE__) + "/../../public/images/boxart/#{imdb_id}.jpg")
  end
  
  def boxart_url
    "/images/boxart/#{imdb_id}.jpg"
  end

  def import!
    valid?
    return false if errors.on(:imdb_id)
    begin
      return imdb_update!
    rescue OpenURI::HTTPError => e
      errors.add(:imdb_id, "does not exist. Please use the full ID (ex tt0338526).")
      return false
    end
  end
  
  def has_language?(language)
    languages.collect(&:name).include?(language)
  end

  def has_country?(country)
    countries.collect(&:name).include?(country)
  end
  
  def imdb_update
    imdb_movie = Imdb.find_movie_by_id(self.imdb_id)
    self.name = imdb_movie.title
    self.imdb_rating = imdb_movie.rating if imdb_movie.rating
    self.runtime = imdb_movie.runtime.to_i if imdb_movie.runtime
    self.tag_list = imdb_movie.genres.collect(&:name).join(",") if imdb_movie.genres
    self.year = imdb_movie.release_date.year if imdb_movie.release_date

    if imdb_movie.languages
      imdb_movie.languages.each do |language|
        self.languages << Language.find_or_create_by_name(language) unless self.has_language?(language)
      end
    end
    
    if imdb_movie.countries
      imdb_movie.countries.each do |country|
        self.countries << Country.find_or_create_by_name(country) unless self.has_country?(country)
      end
    end

    if !has_boxart? && !imdb_movie.poster_url.nil?
      File.open(boxart_path, "w+")
      rio(boxart_path).binmode < rio(imdb_movie.poster_url)
      self.boxart = "#{imdb_id}.jpg"
    else
      self.boxart = ""
    end
  end
  
  def imdb_update!
    imdb_update
    save
  end
end