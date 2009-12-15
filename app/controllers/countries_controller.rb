class CountriesController < ResourceController::Base
  cattr_reader :order
  @@order = { :name => "name", :abbreviation => "abbreviation", :count => "movies_count" }
  
  private
  def collection
    Country.paginate :page => params[:page], :order => build_order
  end
end