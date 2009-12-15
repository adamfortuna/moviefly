require 'digest/sha1'

class User < ActiveRecord::Base
  extend ActiveSupport::Memoizable
  include Authentication
  include Authentication::ByCookieToken

  # Validations
  validate :normalize_identity_url
  validates_uniqueness_of :identity_url

  validate :create_username_from_identity_url, :if => Proc.new { |u| u.username.blank? }
  validates_presence_of :username
  validates_length_of :username, :within => 3..40
  validates_uniqueness_of :username, :case_sensitive => false
  validates_format_of :username, :with => RE_LOGIN_OK, :message => MSG_LOGIN_BAD
  
  validates_format_of :name, :with => RE_NAME_OK, :message => MSG_NAME_BAD, :allow_nil => true
  validates_length_of :name, :maximum => 100, :allow_nil => true

  validates_numericality_of :rating_step, :greater_than_or_equal_to => 0.01, :less_than_or_equal_to => 20, :message => "must be a number from .01 - 20."
  
  has_permalink :username
  
  # Relationships
  has_and_belongs_to_many :roles
  
  has_many :friendships
  has_many :friends, :through => :friendships, :class_name => 'User'
  belongs_to :friendship, :foreign_key => "friendship_id"
  has_many :reviews
  has_many :ratings
  has_many :ownerships
  has_many :emails
  
  has_many :movies, :through => :movieships, :order => 'movies.name'
  has_many :movieships

  has_many :views
  has_many :viewships, :as => :viewable

  is_gravtastic :email, :size => 40

  
  # HACK HACK HACK -- how to do attr_accessible from here?
  # prevents a user from submitting a crafted form that bypasses activation
  # anything else you want your user to change should be added here.
  attr_accessible :username, :name, :identity_url, :about, :all_emails, :rating_step
  attr_accessor :current_ownerships, :current_reviews, :current_ratings
  
  def all_emails=(emails)
    email_addresses = self.emails.collect(&:email)
    emails.each do |email|
      # Check to see if this user has this email already
      unless email_addresses.include?(email)
        self.emails << Email.new({:email => email, :pending_claim_by => self})
      end
    end
  end
  
  def email
    begin
      self.emails.confirmed.first.email
    rescue
      ""
    end
  end

  # Check if a user has a role.
  def has_role?(role)
    list ||= self.roles.map(&:name)
    list.include?(role.to_s) || list.include?('admin')
  end
  
  def to_param
    permalink
  end
  
  def friends_with?(user)
    friends.include?(user)
  end
  memoize :friends_with?
  def friendship_for(user)
    friendships.find_by_friend_id(user.id)
  end
  
  

  def _viewships
    viewships.find(:all, :include => :view)
  end
  memoize :_viewships
  def viewed_movie_ids
    _viewships.collect(&:movie_id)
  end
  memoize :viewed_movie_ids
  def seen?(movie, type='one')
    return (seen_count(movie, type) > 0) if type=='one'
    return viewed_movie_ids.include?(movie.id)
  end
  memoize :seen?
  def seen_count(movie, type='one')
    return viewships.count(:conditions => ['movie_id=?', movie.id]) if type=='one'
    return viewed_movie_ids.select { |m| m == movie.id }.length
  end
  memoize :seen_count

  def attended_movies
    View.find(:all, :conditions => ["viewship.viewable_id=? AND viewship.viewable_type=?", self.id, "User"], :include => :viewships)
  end
  def attended_movie(movie_id)
    View.find(:all, :conditions => ["views.movie_id=? AND viewships.viewable_id=? AND viewships.viewable_type=?", movie_id, self.id, "User"], :include => :viewships)
  end



  def _reviews
    self.current_reviews ||= reviews
  end
  memoize :_reviews
  def reviewed?(movie, type="one")
    review = review_for(movie, type)
    !review.nil? && review.reviewed?
  end
  memoize :reviewed?
  def review_for(movie, type="one")
    # This is faster for getting a single review, as with the movie review page
    return reviews.find_by_reviewable_id(movie.id) if type == "one"
    # This is faster for getting a lot of reviews, like on a listing page
    return _reviews.select { |m| m.reviewable_id == movie.id }.first
  end
  memoize :review_for
  


  def _ratings
    self.current_ratings ||= ratings
  end
  memoize :_ratings
  def rated?(movie, type="one")
    rating_for(movie, type) ? true : false
  end
  memoize :rated?  
  def rating_for(movie, type="one")
    # This is faster for getting a single rating, as with the movie ratings page
    return ratings.find_by_movie_id(movie.id) if type == "one"
    # This is faster for getting a lot of ratings, like on a listing page
    return _ratings.select { |m| m.movie_id == movie.id }.first    
  end
  memoize :rating_for




  def _ownerships
    self.current_ownerships ||= ownerships.find(:all, :include => :media)
  end
  memoize :_ownerships
  def ownerships_movie_ids
    _ownerships.collect(&:movie_id)
  end
  memoize :ownerships_movie_ids
  def owns?(movie, type="one")
    return ownerships.count(:conditions => ["movie_id=?", movie.id]) if type=="one"
    return ownerships_movie_ids.include?(movie.id)
  end
  memoize :owns?
  def ownerships_for(movie, type="one")
    return ownerships.find(:all, :conditions => ["movie_id=?", movie.id], :include => :media) if type=="one"
    return _ownerships.select { |m| m.movie_id == movie.id }
  end
  memoize :ownerships_for
  def ownerships_count(movie)
    ownerships_movie_ids.select { |m| m == movie.id }.length
  end
  memoize :ownerships_count
  def ownerships_lists_for(movie, type="one")
    ownerships_for(movie, type).collect(&:media).collect(&:name).join(", ")
  end
  memoize :ownerships_lists_for


  def _movieships
    movieships
  end
  memoize :_movieships
  def movieships_movie_ids
    _movieships.collect(&:movie_id)
  end
  memoize :movieships_movie_ids
  def monitoring?(movie)
    movieships_movie_ids.include?(movie.id)
  end
  memoize :monitoring?
  def movieship_for(movie)
    _movieships.select { |m| m.movie_id == movie.id }
  end

  protected

  def normalize_identity_url
    self.identity_url = OpenIdAuthentication.normalize_identifier(identity_url)
  rescue URI::InvalidURIError
    errors.add_to_base("Invalid OpenID URL")
  end

  def create_username_from_identity_url  
    self.username = OpenidProviders.extract_username(self.identity_url) || (User.last.id+1).to_s.rjust(6,"0")
    create_unique_permalink
    self.username = self.permalink
  end
  
  # def add_or_claim_email
  #   e = Email.find_by_email(self.email)
  #   if e
  #     e.claim!(self)
  #     e.viewships.each do |viewship|
  #       viewship.claim!(self)
  #     end
  #   else
  #     Email.create({ :user_id => self.id, :email => self.email, :confirmed => true })
  #   end
  # end
end
