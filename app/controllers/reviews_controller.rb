class ReviewsController < ResourceController::Base
  belongs_to :movie, :user
  before_filter :set_parent, :only => [:create, :update]
  
  private
  
  index.wants.html { 
    if parent_type == :user
      render :template => "user_reviews/index" 
    else
      render :template => "movie_reviews/index"
    end
  }
  show.wants.html { 
    if parent_type == :user
      render :template => "user_reviews/show" 
    else
      render :template => "movie_reviews/show"
    end
  }
  new_action.wants.html { 
    if parent_type == :user
      render :template => "user_reviews/new" 
    else
      render :template => "movie_reviews/new"
    end
  }
  new_action.wants.js { 
    render :template => "movie_reviews/new.rjs" if parent_type == :movie
  }
  edit.wants.html { 
    if parent_type == :user
      render :template => "user_reviews/edit" 
    else
      render :template => "movie_reviews/edit"
    end
  }
  
  def parent_object
    return @parent_object if @parent_object
    if parent_type == :movie
      @parent_object = Movie.find_by_permalink(params[:movie_id])
    else
      @parent_object = User.find_by_permalink(params[:user_id])
    end
    raise ActiveRecord::RecordNotFound if @parent_object.nil?
    return @parent_object
  end
  
  def collection
    parent_object.reviews.paginate(:all, :include => [:user, :reviewable], :conditions => "reviews.review IS NOT NULL AND reviews.review!=''", :page => params[:page])
  end
  
  def set_parent
    params[:review][:user] = current_user
  end
  
  destroy.wants.html {
    redirect_to movie_url(@movie)
  }
end