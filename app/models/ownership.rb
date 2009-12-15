class Ownership < ActiveRecord::Base
  belongs_to :movie, :counter_cache => true # movie.ownerships_count
  belongs_to :user, :counter_cache => true  # user.ownerships_count
  belongs_to :media, :counter_cache => true # media.ownerships_count
  
  after_create :create_movieship
  def create_movieship
    Movieship.create({ :user => user, :movie => movie })
  end
end