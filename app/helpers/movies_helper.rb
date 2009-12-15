module MoviesHelper
  def movie_languages(languages)
    s = "<ul>"
    languages.each do |l|
      s += "<li>#{link_to l.name, language_movies_path(l)}</li>"
    end
    s += "</ul>"
    s
  end
  
  def movie_countries(countries)
    s = "<ul>"
    countries.each do |c|
      s += "<li>#{link_to c.name, country_movies_path(c)}</li>"
    end
    s += "</ul>"
    s
  end

  def movie_tags(tags)
    s = "<ul>"
    tags.each do |g|
      s += "<li>#{link_to g.name, tag_movies_path(g)}</li>"
    end
    s += "</ul>"
    s
  end
  
  
  
end