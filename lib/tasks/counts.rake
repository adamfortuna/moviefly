namespace :counts do

  desc "Update the count columns on all tables"  
  task :update => :environment do
    User.update_all 'viewships_count=0, movieships_count=0, ownerships_count=0, reviews_count=0'
    User.find(:all, :include => :viewships, :conditions => 'viewships.id IS NOT NULL').each do |user|
      User.update_all ['viewships_count=?', user.viewships.count], ['id=?', user.id]
    end
    User.find(:all, :include => :movieships, :conditions => 'movieships.id IS NOT NULL').each do |user|
      User.update_all ['movieships_count=?', user.movieships.count], ['id=?', user.id]
    end
    User.find(:all, :include => :reviews, :conditions => 'reviews.id IS NOT NULL').each do |user|
      User.update_all ['reviews_count=?', user.reviews.count], ['id=?', user.id]
    end
    User.find(:all, :include => :ownerships, :conditions => 'ownerships.id IS NOT NULL').each do |user|
      User.update_all ['ownerships_count=?', user.ownerships.count], ['id=?', user.id]
    end
    
    
    Movie.update_all 'viewships_count=0, movieships_count=0, ownerships_count=0, reviews_count=0'
    Movie.find(:all, :include => :viewships, :conditions => 'viewships.id IS NOT NULL').each do |movie|
      Movie.update_all ['viewships_count=?', movie.viewships.count], ['id=?', movie.id]
    end
    Movie.find(:all, :include => :movieships, :conditions => 'movieships.id IS NOT NULL').each do |movie|
      Movie.update_all ['movieships_count=?', movie.movieships.count], ['id=?', movie.id]
    end
    Movie.find(:all, :include => :reviews, :conditions => 'reviews.id IS NOT NULL').each do |movie|
      Movie.update_all ['reviews_count=?', movie.reviews.count], ['id=?', movie.id]
    end
    Movie.find(:all, :include => :ownerships, :conditions => 'ownerships.id IS NOT NULL').each do |movie|
      Movie.update_all ['ownerships_count=?', movie.ownerships.count], ['id=?', movie.id]
    end
    

    Media.update_all 'ownerships_count=0'
    Media.find(:all, :include => :ownerships, :conditions => 'ownerships.id IS NOT NULL').each do |media|
      Media.update_all ['ownerships_count=?', media.ownerships.count], ['id=?', media.id]
    end
    
    Language.update_all 'movies_count=0'
    Language.find(:all, :include => :movies, :conditions => 'movies.id IS NOT NULL').each do |language|
      Language.update_all ['movies_count=?', language.movies.count], ['id=?', language.id]
    end

    Country.update_all 'movies_count=0'
    Country.find(:all, :include => :movies, :conditions => 'movies.id IS NOT NULL').each do |country|
      Country.update_all ['movies_count=?', country.movies.count], ['id=?', country.id]
    end
    
  end
end