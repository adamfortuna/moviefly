class Viewship < ActiveRecord::Base
  belongs_to :view
  belongs_to :viewable, :polymorphic => true, :counter_cache => true # user.viewships_count

  # movie_id is actually a duplicate of the parent view.movie_id and is not required.
  # it's included here for convenience sake.
  belongs_to :movie, :counter_cache => true # movie.viewships

  validates_uniqueness_of :user_id, :scope => :view_id
  
  def confirm!
    update_attribute(:confirmed, true)
  end
  
  def creator?(_user)
    view.creator?(_user)
  end
  
  def unconfirmed?
    !confirmed
  end
  
  after_create :create_movieship
  def create_movieship
    Movieship.create({ :user => user, :movie => movie })
  end
  
  delegate :on, :to => :view
  
  
  def claim!(claimed_user)
    self.viewable = claimed_user
    self.save
  end
end