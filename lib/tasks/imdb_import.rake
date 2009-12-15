require 'imdb'

namespace :imdb do

  desc "Import a movie from IMDB"
  task :import => :environment do
    
    begin
      puts "Enter an IMDB ID to import a movie: "
      imdb_id = STDIN.gets.chomp
    
      if imdb_id.length == 9
        m = Movie.new(:imdb_id => imdb_id)
        if m.imdb_update!
          puts "Successfully added #{m.name}.\n\n"
        else
          puts "Wasn't able to add imdb_id (#{m.name}). #{m.errors}.\n\n"
        end
      end
    end while imdb_id.length == 9
    
    '\n\nExiting out...'
  end
  
  desc "Update all movies that are missing data"
  task :update => :environment do
    movies = Movie.find(:all)
    movies.each do |movie|
      if movie.imdb_id #&& movie.incomplete?
        movie.import!
        puts "Updated #{movie.title}\n"
      end
    end
  end
end