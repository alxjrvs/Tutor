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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130321145111) do

  create_table "blocks", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "cards", :force => true do |t|
    t.string   "name"
    t.string   "cost"
    t.string   "power"
    t.string   "toughness"
    t.text     "super_types",                     :array => true
    t.text     "sub_types",                       :array => true
    t.text     "card_types",                      :array => true
    t.string   "colors",                          :array => true
    t.string   "color_indicator",                 :array => true
    t.text     "card_text"
    t.integer  "expansion_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "expansions", :force => true do |t|
    t.string   "name"
    t.string   "short_name"
    t.string   "tagline"
    t.boolean  "mythicable"
    t.date     "release_date"
    t.integer  "block_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "printings", :force => true do |t|
    t.text     "raw_text"
    t.text     "rules_text"
    t.string   "name"
    t.text     "flavor_text"
    t.text     "watermark"
    t.string   "illustrator"
    t.string   "rarity"
    t.string   "card_number"
    t.string   "gatherer_url"
    t.integer  "multiverse_number"
    t.integer  "card_id"
    t.integer  "expansion_id"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

end
