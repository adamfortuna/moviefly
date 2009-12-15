class GenresController < ResourceController::Base
  cattr_reader :order
  @@order = { :name => "name", :count => "taggings_count" }

  private
  def collection
    Tag.paginate :per_page => 100, :page => params[:page], :order => build_order
  end
end