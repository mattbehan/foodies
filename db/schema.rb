# encoding: UTF-8
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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20151013205534) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "articles", force: :cascade do |t|
    t.integer  "author_id",  null: false
    t.string   "title",      null: false
    t.text     "content",    null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "articles", ["author_id"], name: "index_articles_on_author_id", using: :btree

  create_table "bookmarks", force: :cascade do |t|
    t.integer  "bookmarker_id",            null: false
    t.integer  "bookmarked_restaurant_id", null: false
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  add_index "bookmarks", ["bookmarked_restaurant_id"], name: "index_bookmarks_on_bookmarked_restaurant_id", using: :btree
  add_index "bookmarks", ["bookmarker_id"], name: "index_bookmarks_on_bookmarker_id", using: :btree

  create_table "comments", force: :cascade do |t|
    t.text     "content",    null: false
    t.integer  "user_id",    null: false
    t.integer  "review_id",  null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "comments", ["review_id"], name: "index_comments_on_review_id", using: :btree
  add_index "comments", ["user_id"], name: "index_comments_on_user_id", using: :btree

  create_table "dishes", force: :cascade do |t|
    t.string   "name",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "followings", force: :cascade do |t|
    t.integer  "follower_id",      null: false
    t.integer  "followed_user_id", null: false
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_index "followings", ["followed_user_id"], name: "index_followings_on_followed_user_id", using: :btree
  add_index "followings", ["follower_id"], name: "index_followings_on_follower_id", using: :btree

  create_table "identities", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "provider"
    t.string   "accesstoken"
    t.string   "refreshtoken"
    t.string   "uid"
    t.string   "name"
    t.string   "email"
    t.string   "nickname"
    t.string   "image"
    t.string   "phone"
    t.string   "urls"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "identities", ["user_id"], name: "index_identities_on_user_id", using: :btree

  create_table "profiles", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "full_name"
    t.string   "affiliation"
    t.text     "bio"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "quick_takes", force: :cascade do |t|
    t.integer  "rater_id",      null: false
    t.integer  "restaurant_id", null: false
    t.integer  "rating",        null: false
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "quick_takes", ["rater_id"], name: "index_quick_takes_on_rater_id", using: :btree
  add_index "quick_takes", ["restaurant_id"], name: "index_quick_takes_on_restaurant_id", using: :btree

  create_table "restaurants", force: :cascade do |t|
    t.string   "name",               null: false
    t.string   "cuisine"
    t.string   "street_address",     null: false
    t.string   "city",               null: false
    t.string   "state",              null: false
    t.string   "zip",                null: false
    t.string   "phone_number"
    t.string   "neighborhood"
    t.string   "nearest_l"
    t.string   "website"
    t.string   "menu_url"
    t.integer  "price_scale",        null: false
    t.string   "atmosphere"
    t.boolean  "delivery"
    t.boolean  "reservations"
    t.integer  "vegan_friendliness"
    t.boolean  "patios"
    t.string   "dress_code"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  add_index "restaurants", ["city"], name: "index_restaurants_on_city", using: :btree
  add_index "restaurants", ["cuisine"], name: "index_restaurants_on_cuisine", using: :btree
  add_index "restaurants", ["name"], name: "index_restaurants_on_name", using: :btree
  add_index "restaurants", ["neighborhood"], name: "index_restaurants_on_neighborhood", using: :btree
  add_index "restaurants", ["state"], name: "index_restaurants_on_state", using: :btree
  add_index "restaurants", ["zip"], name: "index_restaurants_on_zip", using: :btree

  create_table "reviews", force: :cascade do |t|
    t.string   "title",         null: false
    t.text     "content",       null: false
    t.integer  "rating",        null: false
    t.integer  "restaurant_id", null: false
    t.integer  "reviewer_id",   null: false
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "reviews", ["restaurant_id"], name: "index_reviews_on_restaurant_id", using: :btree
  add_index "reviews", ["reviewer_id"], name: "index_reviews_on_reviewer_id", using: :btree

  create_table "specialties", force: :cascade do |t|
    t.integer  "restaurant_id", null: false
    t.integer  "dish_id",       null: false
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "specialties", ["dish_id"], name: "index_specialties_on_dish_id", using: :btree
  add_index "specialties", ["restaurant_id"], name: "index_specialties_on_restaurant_id", using: :btree

  create_table "taggings", force: :cascade do |t|
    t.integer  "tag_id",        null: false
    t.integer  "restaurant_id", null: false
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "taggings", ["restaurant_id"], name: "index_taggings_on_restaurant_id", using: :btree
  add_index "taggings", ["tag_id"], name: "index_taggings_on_tag_id", using: :btree

  create_table "tags", force: :cascade do |t|
    t.string   "name",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "",     null: false
    t.string   "encrypted_password",     default: ""
    t.string   "role",                   default: "user"
    t.string   "username",                                null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,      null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.integer  "failed_attempts",        default: 0,      null: false
    t.datetime "locked_at"
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
    t.string   "invitation_token"
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer  "invitation_limit"
    t.integer  "invited_by_id"
    t.string   "invited_by_type"
    t.string   "provider"
    t.string   "uid"
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["invitation_token"], name: "index_users_on_invitation_token", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["username"], name: "index_users_on_username", unique: true, using: :btree

  create_table "visits", force: :cascade do |t|
    t.integer  "visited_restaurant_id", null: false
    t.integer  "visitor_id",            null: false
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  add_index "visits", ["visited_restaurant_id"], name: "index_visits_on_visited_restaurant_id", using: :btree
  add_index "visits", ["visitor_id"], name: "index_visits_on_visitor_id", using: :btree

  create_table "votes", force: :cascade do |t|
    t.integer  "value",        default: 0, null: false
    t.string   "votable_type",             null: false
    t.integer  "votable_id",               null: false
    t.integer  "user_id",                  null: false
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  add_index "votes", ["user_id"], name: "index_votes_on_user_id", using: :btree
  add_index "votes", ["votable_id"], name: "index_votes_on_votable_id", using: :btree

  add_foreign_key "identities", "users"
end
