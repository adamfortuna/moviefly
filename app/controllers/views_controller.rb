class ViewsController < ResourceController::Base
  belongs_to :movie
  before_filter :set_parent, :only => [:create, :update]
  before_filter :set_user, :only => [:index, :new, :create]
  before_filter :create_existing_if_empty, :only => [:update]

  private

  index.wants.html { 
    if @user
      render :template => "user_views/index" 
    elsif parent_type == :movie
      render :template => "movie_views/index"
    end
  }
 
  new_action.wants.html { 
    render :template => "user_views/new" 
  }
    
  def parent_object
    return @parent_object if @parent_object
    @parent_object = Movie.find_by_permalink(params[:movie_id]) if parent_type == :movie
    raise ActiveRecord::RecordNotFound if @parent_object.nil?
    @parent_object
  end

  def collection
    if @user
      @user.attended_movie(parent_object.id)
    else
      parent_object.viewships.find(:all, :include => :view)
    end
  end
  

  def set_parent
    params[:view][:user] = current_user
  end
  
  def set_user
    @user = User.find_by_permalink params[:user_id] if params[:user_id]
  end
  
  def create_existing_if_empty
    params[:view][:existing_viewship_attributes] = {} unless params[:view][:existing_viewship_attributes]
  end
end