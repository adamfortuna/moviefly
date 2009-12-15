class Rating < ActiveRecord::Base
  belongs_to :user, :counter_cache => true # user.ratings_count
  belongs_to :movie, :counter_cache => true # movie.ratings_count
  
  validates_presence_of :user, :movie
  
  validates_numericality_of :rating, :greater_than_or_equal_to => 0, :less_than_or_equal_to => 100, :message => "must be a number from 1-100."
  validates_uniqueness_of :movie_id, :scope => [:user_id]
  
  def self.create_or_update(options)
    rating = Rating.find_by_user_id_and_movie_id(options[:user_id], options[:movie_id])
    if rating
      rating.update_attribute(:rating, options[:rating])
    else
      Rating.create(:user_id => options[:user_id],
                    :movie_id => options[:movie_id],
                    :rating => options[:rating])
    end
  end
end