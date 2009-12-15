class ApplicationController < ActionController::Base
  include ExceptionNotifiable
  include AuthenticatedSystem
  include RoleRequirementSystem

  helper :all # include all helpers, all the time
  filter_parameter_logging :password, :password_confirmation
  rescue_from ActiveRecord::RecordNotFound, :with => :record_not_found
  
  protected
  
  # Automatically respond with 404 for ActiveRecord::RecordNotFound
  def record_not_found
    render :file => File.join(RAILS_ROOT, 'public', '404.html'), :status => 404
  end
  
  ActiveScaffold.set_defaults do |config| 
    config.ignore_columns.add [:created_at, :updated_at, :lock_version]
  end
  
  def self.order(default, columns)
    define_method(:order) do 
      @sorter = MySortingHelper::Sorter.new(params.clone, columns)
      params[:order].blank? && params[:sort].blank? ? default : @sorter.sort_param 
    end
  end
  
  def build_order
    params[:order] ||= "name"
    params[:direction] ||= "asc"
    params[:direction] = "desc" unless params[:direction] == "asc"
    "#{order[params[:order].to_sym]} #{params[:direction]}"
  end
  
end