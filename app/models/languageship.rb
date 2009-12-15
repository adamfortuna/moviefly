class Languageship < ActiveRecord::Base
  belongs_to :movie
  belongs_to :language, :counter_cache => :movies_count
end