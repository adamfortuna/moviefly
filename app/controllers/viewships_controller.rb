class ViewshipsController < ResourceController::Base
  belongs_to :movie

  def confirm
    object.confirm!
    flash[:notice] = "You confirmed a viewing of <b>#{object.movie.name}</b>."
    redirect_to user_movie_views_path(current_user, object.movie)
  end

  private
  def object
    Viewship.find params[:id]
  end
  def parent_object
    return @parent_object if @parent_object
    @parent_object = Movie.find_by_permalink(params[:movie_id]) if parent_type == :movie
    raise ActiveRecord::RecordNotFound if @parent_object.nil?
    return @parent_object
  end  
end