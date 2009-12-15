class Review < ActiveRecord::Base
  extend ActiveSupport::Memoizable
  belongs_to :reviewable, :polymorphic => true, :counter_cache => true # movie.reviews_count
  belongs_to :user, :counter_cache => true                             # user.reviews_count
  
  validates_presence_of :user

  validates_uniqueness_of :reviewable_id, :scope => :user_id, :message => "It looks like you've already reveiwed this movie. You should edit your existing review."
  
  after_create :create_viewship_if_unviewed
  
  # named_scope :rating_only, :conditions => ['review is NULL or review = ""']
  # named_scope :with_review, :conditions => ['review is NOT NULL AND review != ""']

  def movie
    reviewable
  end

  def reviewed?
    !review.blank?
  end
  
  # def rated?
  #   rating && rating > 0
  # end
  
  def rating
    Rating.find_by_user_id_and_movie_id(user_id, reviewable_id)
  end
  memoize :rating
  
  def create_viewship_if_unviewed  
    if reviewable.is_a?(Movie)
      viewships = user.viewships.find(:all, :conditions => ['views.movie_id = ?', self.reviewable_id], :include => :view)
      View.create({:movie => reviewable, :user => user}) if viewships.empty?
    end
    true
  end
  
  after_create :create_movieship
  def create_movieship
    Movieship.create({ :user => user, :movie => reviewable })
  end
end