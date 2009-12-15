class Movieship < ActiveRecord::Base
  belongs_to :movie, :counter_cache => true # movie.movieships_count
  belongs_to :user, :counter_cache => true  # user.movieships_count
  
  validates_uniqueness_of :user_id, :scope => :movie_id
  
  before_create :check_for_duplicate
  
  def self.destroy_if_unused(movie, user)
    if !user.seen?(movie) && !user.review_for(movie) && user.owns?(movie)
      Movieship.delete_all ["user_id=? AND movie_id=?", user.id, movie.id]
    end
  end
  
  def check_for_duplicate
    !Movieship.exists?(:movie_id => movie.id, :user_id => user.id)
  end
end