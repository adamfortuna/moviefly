class RatingsController < ResourceController::Base
  belongs_to :movie, :user
  
  def create
    Rating.create_or_update(:user_id => current_user.id,
                  :movie_id => parent_object.id,
                  :rating => params[:rating])
    respond_to do |format|
      format.js { render :template => "movie_ratings/create.rjs" }
    end
  end

  # called when a rating is 0
  def destroy
    current_user.rating_for(parent_object).destroy
    respond_to do |format|
      format.js { render :template => "movie_ratings/destroy.rjs" }
    end
    
  end

  private
  
  index.wants.html { 
    if parent_type == :user
      render :template => "user_ratings/index" 
    else
      render :template => "movie_ratings/index"
    end
  }

  def collection
    parent_object.ratings.paginate(:all, :include => [:movie], :page => params[:page])
  end

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
end