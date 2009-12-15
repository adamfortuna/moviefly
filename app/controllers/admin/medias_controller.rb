class Admin::MediasController < ApplicationController
  active_scaffold :media
  layout "admin"
  
  active_scaffold :media do |config|
    config.columns = [:name]
  end
end