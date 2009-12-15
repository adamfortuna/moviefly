class LanguagesController < ResourceController::Base
  cattr_reader :order
  @@order = { :name => "name", :abbreviation => "abbreviation", :count => "movies_count" }
  
  private
  def collection
    Language.paginate :page => params[:page], :order => build_order
  end
end