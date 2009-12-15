class MovieshipsController < ApplicationController
  def destroy
    movieship = current_user.movieships.find(params[:id])
    @movie = movieship.movie
    movieship.destroy
    
    respond_to do |format|
      format.js {
        if !movieship.nil? && movieship.frozen?
          render
        else
          render :update do |page|
            page.alert("There was a problem removing this movie. Refresh the page and try again")
          end
        end
      }
    end
  end
  
  def create
    @movie = Movie.find(params[:movie_id])
    movieship = current_user.movieships.find_by_movie_id(params[:movie_id])
    if movieship.nil?
      @movieship = current_user.movieships.build({:movie_id => params[:movie_id]})
      @movieship.save
    end
    
    respond_to do |format|
      format.js {
        if current_user.monitoring?(@movie)
          render
        else
          render :update do |page|
            page.alert("You already added this movie. ")
          end
        end
      }
    end    
    
  end
end
