# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20090729030452) do

  create_table "countries", :force => true do |t|
    t.string   "name"
    t.string   "abbreviation"
    t.integer  "movies_count"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "permalink"
  end

  create_table "countryships", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "movie_id",   :null => false
    t.integer  "country_id", :null => false
  end

  add_index "countryships", ["country_id"], :name => "index_countryships_on_country_id"
  add_index "countryships", ["movie_id", "country_id"], :name => "index_countryships_on_movie_id_and_country_id", :unique => true
  add_index "countryships", ["movie_id"], :name => "index_countryships_on_movie_id"

  create_table "emails", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.string   "email"
    t.string   "name"
    t.string   "claim_code"
    t.boolean  "confirmed",  :default => false
  end

  create_table "friendships", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id",    :null => false
    t.integer  "friend_id",  :null => false
  end

  create_table "languages", :force => true do |t|
    t.string   "name"
    t.string   "abbreviation"
    t.integer  "movies_count"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "permalink"
  end

  create_table "languageships", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "movie_id",    :null => false
    t.integer  "language_id", :null => false
  end

  add_index "languageships", ["language_id"], :name => "index_languageships_on_language_id"
  add_index "languageships", ["movie_id", "language_id"], :name => "index_languageships_on_movie_id_and_language_id", :unique => true
  add_index "languageships", ["movie_id"], :name => "index_languageships_on_movie_id"

  create_table "lists", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.string   "title"
    t.text     "serialized_conditions"
    t.text     "serialized_order"
  end

  create_table "medias", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.string   "permalink"
    t.integer  "ownerships_count", :default => 0
  end

  create_table "movies", :force => true do |t|
    t.string   "name"
    t.string   "alias"
    t.integer  "year"
    t.integer  "rating",           :limit => 10, :precision => 10, :scale => 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "imdb_id"
    t.string   "permalink"
    t.integer  "votes",                                                         :default => 0
    t.float    "imdb_rating"
    t.integer  "runtime"
    t.integer  "reviews_count",                                                 :default => 0
    t.integer  "ownerships_count",                                              :default => 0
    t.integer  "movieships_count",                                              :default => 0
    t.integer  "viewships_count",                                               :default => 0
    t.string   "boxart"
    t.integer  "ratings_count",                                                 :default => 0
  end

  create_table "movieships", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "movie_id",   :null => false
    t.integer  "user_id",    :null => false
  end

  create_table "open_id_authentication_associations", :force => true do |t|
    t.integer "issued"
    t.integer "lifetime"
    t.string  "handle"
    t.string  "assoc_type"
    t.binary  "server_url"
    t.binary  "secret"
  end

  create_table "open_id_authentication_nonces", :force => true do |t|
    t.integer "timestamp",  :null => false
    t.string  "server_url"
    t.string  "salt",       :null => false
  end

  create_table "ownerships", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "movie_id",                  :null => false
    t.integer  "user_id",                   :null => false
    t.integer  "media_id",                  :null => false
    t.integer  "count",      :default => 1
    t.string   "notes"
  end

  create_table "passwords", :force => true do |t|
    t.integer  "user_id"
    t.string   "reset_code"
    t.datetime "expiration_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ratings", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id",    :null => false
    t.integer  "movie_id",   :null => false
    t.float    "rating",     :null => false
  end

  create_table "reviews", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "reviewable_id"
    t.string   "reviewable_type"
    t.string   "title"
    t.text     "review"
    t.integer  "user_id"
    t.boolean  "has_spoilers",    :default => false
  end

  add_index "reviews", ["reviewable_id", "reviewable_type"], :name => "index_reviews_on_reviewable_id_and_reviewable_type"

  create_table "roles", :force => true do |t|
    t.string "name"
  end

  create_table "roles_users", :id => false, :force => true do |t|
    t.integer "role_id"
    t.integer "user_id"
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "taggings", :force => true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id"], :name => "index_taggings_on_tag_id"
  add_index "taggings", ["taggable_id", "taggable_type"], :name => "index_taggings_on_taggable_id_and_taggable_type"

  create_table "tags", :force => true do |t|
    t.string  "name"
    t.string  "permalink"
    t.integer "taggings_count", :default => 0, :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "username",                  :limit => 40
    t.string   "identity_url"
    t.string   "name",                      :limit => 100, :default => ""
    t.string   "remember_token",            :limit => 40
    t.datetime "remember_token_expires_at"
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "permalink"
    t.integer  "reviews_count",                            :default => 0
    t.integer  "ownerships_count",                         :default => 0
    t.integer  "movieships_count",                         :default => 0
    t.integer  "viewships_count",                          :default => 0
    t.text     "about"
    t.integer  "ratings_count",                            :default => 0
    t.float    "rating_step",                              :default => 5.0
  end

  add_index "users", ["username"], :name => "index_users_on_login", :unique => true

  create_table "views", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id",    :null => false
    t.integer  "movie_id",   :null => false
    t.datetime "on"
    t.string   "location"
    t.string   "address"
  end

  create_table "viewships", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "view_id",                          :null => false
    t.integer  "viewable_id",                      :null => false
    t.boolean  "confirmed",     :default => false
    t.integer  "movie_id"
    t.string   "viewable_type"
    t.text     "notes"
  end

end
