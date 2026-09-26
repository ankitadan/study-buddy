# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_09_26_010206) do
  create_table "cards", force: :cascade do |t|
    t.text "answer"
    t.datetime "created_at", null: false
    t.integer "deck_id", null: false
    t.float "ease_factor", default: 2.5, null: false
    t.integer "interval", default: 0, null: false
    t.date "next_review_date"
    t.text "question"
    t.integer "repetition", default: 0, null: false
    t.datetime "updated_at", null: false
    t.index ["deck_id"], name: "index_cards_on_deck_id"
  end

  create_table "decks", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "description"
    t.string "name"
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_decks_on_name", unique: true
  end

  create_table "reviews", force: :cascade do |t|
    t.integer "card_id", null: false
    t.datetime "created_at", null: false
    t.integer "quality", null: false
    t.date "reviewed_on", null: false
    t.datetime "updated_at", null: false
    t.index ["card_id", "reviewed_on"], name: "index_reviews_on_card_id_and_reviewed_on"
    t.index ["card_id"], name: "index_reviews_on_card_id"
  end

  add_foreign_key "cards", "decks"
  add_foreign_key "reviews", "cards"
end
