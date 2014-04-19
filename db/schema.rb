# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20121230102339) do

  create_table "agodas", :force => true do |t|
    t.text     "hotel_name"
    t.text     "address"
    t.text     "address_ii"
    t.integer  "country_id"
    t.string   "country_name"
    t.integer  "city_id"
    t.string   "city_name"
    t.integer  "area_id"
    t.string   "area_name"
    t.text     "hotel_description"
    t.integer  "star_rating"
    t.text     "hotel_web_url"
    t.integer  "number_of_reviews"
    t.float    "user_rating_average"
    t.string   "rate_from"
    t.decimal  "longitude",             :precision => 12, :scale => 6
    t.decimal  "latitude",              :precision => 12, :scale => 6
    t.string   "phone_number"
    t.string   "fax_number"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "current_status",                                       :default => "new"
    t.text     "hotel_mobile_url"
    t.text     "full_address"
    t.string   "notes"
    t.integer  "poi_id"
    t.string   "hotel_translated_name"
    t.text     "images"
    t.string   "zip_code"
  end

  create_table "apn_apps", :force => true do |t|
    t.text     "apn_dev_cert"
    t.text     "apn_prod_cert"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "apn_device_groupings", :force => true do |t|
    t.integer "group_id"
    t.integer "device_id"
  end

  add_index "apn_device_groupings", ["device_id"], :name => "index_apn_device_groupings_on_device_id"
  add_index "apn_device_groupings", ["group_id", "device_id"], :name => "index_apn_device_groupings_on_group_id_and_device_id"
  add_index "apn_device_groupings", ["group_id"], :name => "index_apn_device_groupings_on_group_id"

  create_table "apn_devices", :force => true do |t|
    t.string   "token",                                                          :default => "", :null => false
    t.decimal  "longitude",                       :precision => 12, :scale => 6
    t.decimal  "latitude",                        :precision => 12, :scale => 6
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "last_registered_at"
    t.integer  "profile_id",         :limit => 8
    t.integer  "app_id"
  end

  add_index "apn_devices", ["token"], :name => "index_apn_devices_on_token"

  create_table "apn_group_notifications", :force => true do |t|
    t.integer  "group_id",          :null => false
    t.string   "device_language"
    t.string   "sound"
    t.string   "alert"
    t.integer  "badge"
    t.text     "custom_properties"
    t.datetime "sent_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "apn_group_notifications", ["group_id"], :name => "index_apn_group_notifications_on_group_id"

  create_table "apn_groups", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "app_id"
  end

  create_table "apn_notifications", :force => true do |t|
    t.integer  "device_id",                        :null => false
    t.integer  "errors_nb",         :default => 0
    t.string   "device_language"
    t.string   "sound"
    t.string   "alert"
    t.integer  "badge"
    t.text     "custom_properties"
    t.datetime "sent_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "apn_notifications", ["device_id"], :name => "index_apn_notifications_on_device_id"

  create_table "apn_pull_notifications", :force => true do |t|
    t.integer  "app_id"
    t.string   "title"
    t.string   "content"
    t.string   "link"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "launch_notification"
  end

  create_table "asia_rooms", :force => true do |t|
    t.integer  "poi_id"
    t.text     "hotel_name"
    t.text     "address"
    t.text     "full_address"
    t.integer  "city_id"
    t.string   "city_name"
    t.integer  "country_id"
    t.string   "country_name"
    t.float    "min_rate",                                         :default => 0.0
    t.string   "currency_code"
    t.integer  "number_of_reviews",                                :default => 0
    t.integer  "total_ratings",                                    :default => 0
    t.string   "hotel_web_url"
    t.string   "hotel_mobile_url"
    t.decimal  "longitude",         :precision => 12, :scale => 6
    t.decimal  "latitude",          :precision => 12, :scale => 6
    t.text     "hotel_description"
    t.string   "current_status",                                   :default => "new"
    t.text     "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "bookings", :force => true do |t|
    t.integer  "rooms"
    t.integer  "adults"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "poi_id"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "contact_no"
    t.string   "email"
    t.integer  "children"
    t.text     "comment"
    t.date     "arrival"
    t.date     "departure"
    t.string   "booking_type", :default => "web"
  end

  create_table "comments", :force => true do |t|
    t.text     "content"
    t.integer  "profile_id", :limit => 8
    t.integer  "poi_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "countries", :force => true do |t|
    t.string   "country_name"
    t.string   "country_code"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "total_pois",         :default => 0
    t.integer  "total_destinations", :default => 0
  end

  create_table "description_types", :force => true do |t|
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "descriptions", :force => true do |t|
    t.text     "content"
    t.integer  "parent_id"
    t.string   "table_name"
    t.integer  "description_type_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "descriptions", ["parent_id"], :name => "index_descriptions_on_parent_id"

  create_table "destination_types", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "destinations", :force => true do |t|
    t.string   "destination_name"
    t.text     "description"
    t.integer  "parent_id"
    t.integer  "destination_type_id"
    t.integer  "country_id"
    t.decimal  "longitude",           :precision => 12, :scale => 8
    t.decimal  "latitude",            :precision => 12, :scale => 8
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "total_pois",                                         :default => 0
    t.integer  "total_attractions",                                  :default => 0
    t.integer  "total_hotels",                                       :default => 0
    t.boolean  "top",                                                :default => false
  end

  create_table "facebook_users", :id => false, :force => true do |t|
    t.integer  "profile_id", :limit => 8
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "feeds", :id => false, :force => true do |t|
    t.datetime "created_at"
    t.integer  "profile_id",   :limit => 8
    t.string   "first_name"
    t.string   "last_name"
    t.text     "content"
    t.integer  "poi_id"
    t.string   "name"
    t.string   "country_name"
    t.integer  "country_id"
  end

  create_table "hotel_matches", :force => true do |t|
    t.integer  "source_id"
    t.string   "source_model"
    t.integer  "match_id"
    t.string   "match_model"
    t.string   "match_type",      :default => "guess"
    t.float    "weight_name"
    t.float    "weight_address"
    t.float    "weight_location"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "hotels_combineds", :force => true do |t|
    t.text     "hotel_file_name"
    t.text     "hotel_name"
    t.integer  "rating"
    t.integer  "city_id"
    t.string   "city_file_name"
    t.string   "city_name"
    t.integer  "state_id"
    t.string   "state_file_name"
    t.string   "state_name"
    t.integer  "country_code"
    t.string   "country_file_name"
    t.string   "country_name"
    t.text     "image_id"
    t.text     "address"
    t.float    "min_rate",                                             :default => 0.0
    t.string   "currency_code"
    t.decimal  "latitude",              :precision => 12, :scale => 6
    t.decimal  "longitude",             :precision => 12, :scale => 6
    t.integer  "number_of_reviews"
    t.integer  "consumer_rating"
    t.integer  "property_type"
    t.string   "chain_id"
    t.string   "facilities"
    t.text     "hotel_description"
    t.text     "hotel_description_raw"
    t.text     "images"
    t.text     "hotel_web_url"
    t.text     "hotel_mobile_url"
    t.string   "rate_from"
    t.string   "folder"
    t.string   "filename"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "current_status",                                       :default => "new"
    t.text     "full_address"
    t.string   "notes"
    t.integer  "poi_id"
  end

  create_table "likes", :force => true do |t|
    t.integer  "profile_id", :limit => 8
    t.integer  "poi_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "partner_hotels", :force => true do |t|
    t.integer  "poi_id"
    t.string   "hotel_name"
    t.integer  "destination_id"
    t.integer  "country_id"
    t.float    "min_rate",                                          :default => 0.0
    t.string   "currency_code"
    t.decimal  "longitude",          :precision => 12, :scale => 8
    t.decimal  "latitude",           :precision => 12, :scale => 8
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "hotel_id"
    t.string   "partner_type"
    t.text     "web_partner_url"
    t.text     "mobile_partner_url"
    t.text     "description"
    t.text     "full_address"
    t.string   "partner_label"
  end

  add_index "partner_hotels", ["poi_id"], :name => "index_partner_hotels_on_poi_id"

  create_table "partner_hotels_removed", :id => false, :force => true do |t|
    t.integer  "id",                                                :default => 0,   :null => false
    t.integer  "poi_id"
    t.string   "hotel_name"
    t.integer  "destination_id"
    t.integer  "country_id"
    t.float    "min_rate",                                          :default => 0.0
    t.string   "currency_code"
    t.decimal  "longitude",          :precision => 12, :scale => 8
    t.decimal  "latitude",           :precision => 12, :scale => 8
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "hotel_id"
    t.string   "partner_type"
    t.text     "web_partner_url"
    t.text     "mobile_partner_url"
    t.text     "description"
    t.text     "full_address"
    t.string   "partner_label"
  end

  create_table "pictures", :force => true do |t|
    t.string   "caption_title"
    t.text     "caption_description"
    t.string   "credits_to"
    t.string   "credits_url"
    t.integer  "poi_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
  end

  add_index "pictures", ["poi_id"], :name => "index_pictures_on_poi_id"

  create_table "poi_types", :force => true do |t|
    t.string   "poi_type_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "poi_user_privileges", :force => true do |t|
    t.integer  "poi_id"
    t.integer  "user_id"
    t.boolean  "allowed",    :default => false
    t.string   "allowed_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pois", :force => true do |t|
    t.string    "name"
    t.string    "address"
    t.string    "tel_no"
    t.string    "web_url"
    t.string    "email"
    t.decimal   "longitude",               :precision => 12, :scale => 6
    t.decimal   "latitude",                :precision => 12, :scale => 6
    t.integer   "destination_id"
    t.string    "destination_name"
    t.integer   "country_id"
    t.string    "country_name"
    t.text      "description"
    t.integer   "poi_type_id"
    t.string    "poi_type_name"
    t.float     "total_stars",                                            :default => 0.0
    t.integer   "total_ratings",                                          :default => 0
    t.datetime  "created_at"
    t.datetime  "updated_at"
    t.string    "picture_thumb_path"
    t.string    "picture_full_path"
    t.integer   "total_pictures",                                         :default => 0
    t.float     "min_rate",                                               :default => 0.0
    t.string    "currency_code"
    t.boolean   "featured",                                               :default => false, :null => false
    t.integer   "total_views",                                            :default => 0
    t.timestamp "viewed_at",                                                                 :null => false
    t.boolean   "bookable",                                               :default => false
    t.boolean   "exclusive",                                              :default => false
    t.string    "current_status",                                         :default => "new"
    t.text      "full_address"
    t.string    "booking_email_providers"
    t.boolean   "approved",                                               :default => false
    t.integer   "total_likes",                                            :default => 0
    t.integer   "total_comments",                                         :default => 0
  end

  add_index "pois", ["country_id"], :name => "index_pois_on_country_id"

  create_table "priceline_bookings", :force => true do |t|
    t.integer  "poi_id"
    t.text     "hotel_name"
    t.text     "address"
    t.text     "full_address"
    t.integer  "city_id"
    t.string   "city_name"
    t.integer  "country_id"
    t.string   "country_name"
    t.float    "min_rate",                                         :default => 0.0
    t.string   "currency_code"
    t.integer  "number_of_reviews",                                :default => 0
    t.integer  "total_ratings",                                    :default => 0
    t.string   "hotel_web_url"
    t.string   "hotel_mobile_url"
    t.decimal  "longitude",         :precision => 12, :scale => 6
    t.decimal  "latitude",          :precision => 12, :scale => 6
    t.text     "hotel_description"
    t.string   "current_status",                                   :default => "new"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "notes"
  end

  create_table "raw_agodas", :force => true do |t|
    t.integer  "chain_id"
    t.string   "chain_name"
    t.integer  "brand_id"
    t.string   "brand_name"
    t.string   "hotel_name"
    t.string   "hotel_formerly_name"
    t.string   "hotel_translated_name"
    t.string   "addressline1"
    t.string   "addressline2"
    t.string   "zipcode"
    t.string   "city"
    t.string   "state"
    t.string   "country"
    t.string   "countryisocode"
    t.string   "star_rating"
    t.decimal  "longitude",             :precision => 12, :scale => 6
    t.decimal  "latitude",              :precision => 12, :scale => 6
    t.string   "url"
    t.string   "checkin"
    t.string   "checkout"
    t.string   "numberrooms"
    t.string   "numberfloors"
    t.string   "yearopened"
    t.string   "yearrenovated"
    t.string   "photo1"
    t.string   "photo2"
    t.string   "photo3"
    t.string   "photo4"
    t.string   "photo5"
    t.text     "overview"
    t.integer  "rates_from_usd"
    t.integer  "continent_id"
    t.string   "continent_name"
    t.integer  "city_id"
    t.integer  "country_id"
    t.integer  "number_of_reviews"
    t.float    "rating_average"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "rooms", :force => true do |t|
    t.integer  "partner_hotel_id"
    t.integer  "hotel_id"
    t.string   "partner_type"
    t.string   "room_type"
    t.integer  "occupancy",           :default => 0
    t.float    "rate"
    t.string   "currency_code"
    t.datetime "date_from"
    t.datetime "date_to"
    t.text     "meals"
    t.text     "cancellation_policy"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "supports", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "contact"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "email",                               :default => "",       :null => false
    t.string   "encrypted_password",   :limit => 128, :default => "",       :null => false
    t.string   "reset_password_token"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                       :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "role",                                :default => "normal"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "mobile_no"
    t.string   "tel_no"
    t.string   "fax_no"
    t.string   "address"
    t.integer  "country_id"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

  create_table "web_photos", :force => true do |t|
    t.string   "caption_title"
    t.text     "caption_description"
    t.string   "credits_to"
    t.string   "credits_url"
    t.string   "thumb_path"
    t.string   "full_path"
    t.integer  "poi_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "web_photos", ["poi_id"], :name => "index_web_photos_on_poi_id"

end
