ActionController::Routing::Routes.draw do |map| 
  map.namespace(:admin) do |admin|  
    admin.resources :movies,    :active_scaffold => true
    admin.resources :genres,    :active_scaffold => true
    admin.resources :languages, :active_scaffold => true
    admin.resources :countries, :active_scaffold => true
    admin.resources :medias,    :active_scaffold => true
  end

  # Restful Authentication Rewrites
  map.logout '/logout', :controller => 'sessions', :action => 'destroy'
  map.login '/login', :controller => 'sessions', :action => 'new'
  map.register '/register', :controller => 'users', :action => 'create'
  map.signup '/signup', :controller => 'users', :action => 'new'
  map.open_id_complete '/opensession', :controller => "sessions", :action => "create", :requirements => { :method => :get }
  map.open_id_create '/opencreate', :controller => "users", :action => "create", :requirements => { :method => :get }

  # Restful Authentication Resources
  map.resources :movies do |movie|
    movie.resources :reviews
    movie.resources :views
    movie.resources :ownerships
    movie.resources :tags
    movie.resources :ratings
  end
  
  map.resource :search

  map.resources :users, :has_many => [:viewships, :views, :friendships]
  map.resources :users do |user|
    user.resources :reviews
    user.resources :ratings
    user.resources :viewships
    user.resources :views
    user.resources :friendships
    user.resources :movies do |movie|
      movie.resources :views
      movie.resources :viewships, :member => [ :confirm ]
      movie.resources :ownerships
    end
  end
  
  map.resources :reviews
  map.resource :session

  map.resources :tags,    :has_many => :movies, :controller => 'genres', :as => 'genres'

#  map.resources :genres,    :has_many => :movies
  map.resources :languages, :has_many => :movies
  map.resources :countries, :has_many => :movies
  map.resources :medias, :has_many => :movies
  map.resources :views
  map.resources :viewships
  map.resources :movieships
  
  # Home Page
  map.root :controller => 'home'

  # Install the default routes as the lowest priority.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
