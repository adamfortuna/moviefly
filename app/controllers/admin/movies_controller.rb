class Admin::MoviesController < ApplicationController
  active_scaffold :movie
  layout "admin"  
  
  active_scaffold :movies do |config|
    config.columns = [:name, :alias, :imdb_id, :year, :language, :country, :imdb_rating, :runtime, :permalink, :tags]
    config.list.columns = [:name, :alias, :imdb_id, :year, :language, :country, :permalink, :tag_list, :imdb_rating, :runtime]
    config.list.sorting = { :name => :asc }
    config.list.per_page = 100
    config.columns[:country].ui_type = :select
    config.columns[:language].ui_type = :select
    
    config.columns[:tags].ui_type = :select
  end
  
  protected

  def before_create_save(record)
    record.tag_list = new_tag_list(params[:record][:tags]) if params[:record][:tags]
  end

  def before_update_save(record)
    record.tag_list = new_tag_list(params[:record][:tags]) if params[:record][:tags]
  end

  def new_tag_list(tag_ids)
    tag_ids.map {|k,h| h['id']}.collect {|i| Tag.find(i)}.map do |tag|
      tag.name
    end.join(",")
  end
end
