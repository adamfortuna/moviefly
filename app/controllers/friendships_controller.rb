class FriendshipsController < ResourceController::Base
  belongs_to :user
  before_filter :setup_friendship, :only => :create
    
  private
  def parent_object
    return @parent_object if @parent_object
    @parent_object = User.find_by_permalink(params[:user_id]) if parent_type == :user
    raise ActiveRecord::RecordNotFound if @parent_object.nil?
    return @parent_object
  end
  
  def setup_friendship
    params[:friendship] ||= {}
    params[:friendship][:user] = current_user
    params[:friendship][:friend] = parent_object
  end
end