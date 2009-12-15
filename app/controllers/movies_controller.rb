class MoviesController < ResourceController::Base
  cattr_reader :order
  @@order = { :name => "name", :year => "year", :rating => "rating", :imdb_rating => "imdb_rating", :runtime => "runtime", :reviews_count => "reviews_count", :owners_count => "ownerships_count", :views_count => "viewships_count" }

  belongs_to :language, :country, :genre, :user
  before_filter :setup_filters, :only => :index
  before_filter :setup_style, :only => :index
  
  def create
    @movie = Movie.new(:imdb_id => params[:movie][:imdb_id])
    if @movie.import!
      flash[:notice] = "Successfully created '#{@movie.name}'!"
      redirect_to @movie 
    else
      render :template => "movies/new"
    end
  end
  
  private
  
  index.wants.html { 
    if parent_type == :user
      render :template => "user_movies/index" 
    else
      render :template => "movies/index"
    end
  }
  
  def object
    params[:id] ? Movie.find_by_permalink(params[:id], :include => [:tags, :languages, :countries]) : Movie.new
  end

  def collection
    if params[:search]
      @path = Movie.new
      movies = Movie.search params[:search], :page => params[:page]
    elsif parent_type == :genre
      movies = collection_for_genre
    elsif parent_type == :user
      movies = collection_for_user
    elsif parent_type == :language
      movies = collection_for_parent
    elsif parent_type == :country
      movies = collection_for_parent
    else
      @path = Movie.new
      movies = Movie.paginate :page => params[:page], :order => build_order
    end
    @path ||= [@parent_object, Movie.new]
    movies
  end
  
  
  # Collection types
  def collection_for_user
    movies = parent_object.movies.paginate :page => params[:page], :order => build_order
    ids = movies.collect(&:id)
    @parent_object.current_reviews = parent_object.reviews.find(:all, :conditions => ['reviewable_id IN (?)', ids])
    @parent_object.current_viewships = parent_object.viewships.find(:all, :include => :view, :conditions => ['views.movie_id IN (?)', ids])
    @parent_object.current_ownerships = parent_object.ownerships.find(:all, :include => :media, :conditions => ['movie_id IN (?)', ids])
    movies
  end
  def collection_for_parent
    parent_object.movies.paginate :page => params[:page], :order => build_order
  end
  def collection_for_genre
    Movie.find_tagged_with(@parent_object.name).paginate :page => params[:page], :order => build_order
  end
  
  
  
  

  def parent_object
    return @parent_object if @parent_object
    if parent_type == :language
      @parent_object = Language.find_by_permalink(params[:language_id])
      @filters << "Language: #{@parent_object.name}"
    elsif parent_type == :country
      @parent_object = Country.find_by_permalink(params[:country_id])
      @filters << "Country: #{@parent_object.name}"
    elsif parent_type == :genre
      @parent_object = Tag.find_by_permalink(params[:genre_id])
      @filters << "Genre: #{@parent_object.name}"
    elsif parent_type == :user
      @parent_object = User.find_by_permalink(params[:user_id])
      @filters << "User: #{@parent_object.username}"
      @filters << "Reviewed OR Rated OR Viewed OR Owned"
    end
    raise ActiveRecord::RecordNotFound if @parent_object.nil?
    return @parent_object
  end
  
  
  def setup_filters
    @filters = []
  end
  
  def setup_style
    @style = params[:style] || "box"
    @style = "box" unless ["box", "table", "list"].include?(@style)
  end
end