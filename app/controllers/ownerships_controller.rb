class OwnershipsController < ResourceController::Base
  belongs_to :movie 
  before_filter :set_user
  before_filter :set_existing_ownerships, :only => [:new, :create]

  def create
    params[:ownerships] ||= {}

    # Existing ownerships
    existing_attributes = params[:ownerships][:existing_viewship_attributes] || {}
    @ownerships.reject(&:new_record?).each do |ownership|
      attributes = existing_attributes[ownership.id.to_s]
      if attributes
        attributes.merge!({ :user => @user, :movie => parent_object })
        ownership.attributes = attributes
        ownership.save
      else
        ownership.destroy
      end
    end

    # New ownerships
    new_attributes = params[:ownerships][:new_viewship_attributes]
    if new_attributes
      new_attributes.each do |attributes|
        attributes.merge!({ :user => @user, :movie => parent_object })
        Ownership.create(attributes)
      end
    end
    
    redirect_to user_movie_ownerships_path @user, parent_object
  end
  
  private
  
  index.wants.html { 
    if(@user) 
      render :template => "user_ownerships/index"
    else
      render :template => "movie_ownerships/index"
    end
  }

  new_action.wants.html { 
    if(@user) 
      render :template => "user_ownerships/new"
    else
      redirect_to @movie
    end
  }
  
  
  def parent_object
    return @parent_object if @parent_object
    @parent_object = Movie.find_by_permalink(params[:movie_id]) if parent_type == :movie
    raise ActiveRecord::RecordNotFound if @parent_object.nil?
    return @parent_object
  end
    
  def set_user 
    @user = User.find_by_permalink params[:user_id] if params[:user_id]
  end

  def set_existing_ownerships
    @ownerships = @user.ownerships.find(:all, :conditions => ['movie_id = ?', parent_object.id])
  end
end