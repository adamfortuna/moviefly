class Admin::LanguagesController < ApplicationController
  active_scaffold :language
  layout "admin"
  
  active_scaffold :languages do |config|
    config.columns = [:name, :abbreviation]
  end
end
