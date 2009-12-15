class Countryship < ActiveRecord::Base
  belongs_to :movie
  belongs_to :country, :counter_cache => :movies_count
end