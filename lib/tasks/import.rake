require 'csv'

namespace :import do

  desc "Import all movies"  
  task :movies => :environment do
    
    f = File.new("lib/tasks/movie_list.csv")
    text = f.read
    
    @adam = User.find_by_login "AdamFortuna"
    
    parsed_file = CSV::Reader.parse(text)
    parsed_file.each do |row|
      
      language = Language.find_by_abbreviation(row[11])
      if !language
        language = Language.create({:name => row[11], :abbreviation => row[11]})
      end
      
      
      country = Country.find_by_abbreviation(row[11])
      if !country
        country = Country.create({:name => row[12], :abbreviation => row[11]})
      end
      
      movie = Movie.new
      movie.name = row[0]
      movie.imdb_id = row[1]
      movie.imdb_rating = row[4]
      movie.year = row[6]
      movie.runtime = row[7]
      movie.language = language
      movie.country = country
      
      # Ownerships (format only)
      have_movie = row[2]
      if have_movie == "1"
        media_type = row[10]
        media = Media.find_by_name media_type
        if !media
          media = Media.create({:name => media_type})
        end
        
        ownership = Ownership.new({:user => @adam, :count => 1, :media => media})
        movie.ownerships << ownership
      end
      
      # Review (rating only)
      rating = row[3]
      if rating.to_f > 0
        review = Review.new({ :user => @adam, :rating => rating })
        movie.reviews << review
      end

      movie.save
    end
    
    
    # c=CustomerInformation.new
    # c.job_title=row[1]
    # c.first_name=row[2]
    # c.last_name=row[3]
    # if c.save
    #   n=n+1
    #   GC.start if n%50==0
    # end
  end
end