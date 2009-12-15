class Admin::GenresController < ApplicationController
  active_scaffold :tag
  layout "admin"  
  
  active_scaffold :tag do |config|
    config.columns = [:name, :permalink]
    config.create.link.label = "Add a new genre"
    config.label = "Genres"
  end
end
