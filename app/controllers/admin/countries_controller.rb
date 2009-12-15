class Admin::CountriesController < ApplicationController
  active_scaffold :country
  layout "admin"
  
  active_scaffold :country do |config|
    config.columns = [:name, :abbreviation]
  end
end