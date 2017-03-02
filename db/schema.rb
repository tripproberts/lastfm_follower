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

ActiveRecord::Schema.define(version: 20170302033340) do

  create_table "scrobbler_users", force: :cascade do |t|
    t.string   "username"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.integer  "registered_at_int"
  end

  create_table "scrobbles", force: :cascade do |t|
    t.integer  "track_id"
    t.integer  "uts"
    t.integer  "scrobbler_user_id"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  create_table "tracks", force: :cascade do |t|
    t.string   "artist"
    t.string   "artist_mbid"
    t.string   "name"
    t.string   "mbid"
    t.string   "album"
    t.string   "album_mbid"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

end
