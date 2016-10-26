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

ActiveRecord::Schema.define(version: 20161024101256) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "pokedexes", force: :cascade do |t|
    t.string   "name",              limit: 45
    t.integer  "base_health_point"
    t.integer  "base_attack"
    t.integer  "base_defence"
    t.integer  "base_speed"
    t.string   "element_type",      limit: 45
    t.string   "image_url"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
  end

  create_table "pokemon_battle_logs", force: :cascade do |t|
    t.integer  "pokemon_battle_id"
    t.integer  "turn"
    t.integer  "skill_id"
    t.integer  "damage"
    t.integer  "attacker_id",                              null: false
    t.integer  "attacker_current_health_point"
    t.integer  "defender_id",                              null: false
    t.integer  "defender_current_health_point"
    t.string   "action_type",                   limit: 45
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
    t.index ["pokemon_battle_id"], name: "index_pokemon_battle_logs_on_pokemon_battle_id", using: :btree
    t.index ["skill_id"], name: "index_pokemon_battle_logs_on_skill_id", using: :btree
  end

  create_table "pokemon_battles", force: :cascade do |t|
    t.integer  "pokemon1_id",                          null: false
    t.integer  "pokemon2_id",                          null: false
    t.integer  "current_turn"
    t.string   "state",                     limit: 45
    t.integer  "pokemon_winner_id"
    t.integer  "pokemon_loser_id"
    t.integer  "experience_gain"
    t.integer  "pokemon1_max_health_point"
    t.integer  "pokemon2_max_health_point"
    t.string   "battle_type",               limit: 45
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
  end

  create_table "pokemon_skills", force: :cascade do |t|
    t.integer  "pokemon_id"
    t.integer  "skill_id"
    t.integer  "current_pp"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["pokemon_id"], name: "index_pokemon_skills_on_pokemon_id", using: :btree
    t.index ["skill_id"], name: "index_pokemon_skills_on_skill_id", using: :btree
  end

  create_table "pokemons", force: :cascade do |t|
    t.integer  "pokedex_id"
    t.string   "name",                 limit: 45
    t.integer  "level"
    t.integer  "max_health_point"
    t.integer  "current_health_point"
    t.integer  "attack"
    t.integer  "defence"
    t.integer  "speed"
    t.integer  "current_experience"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.index ["pokedex_id"], name: "index_pokemons_on_pokedex_id", using: :btree
  end

  create_table "skills", force: :cascade do |t|
    t.string   "name",         limit: 45
    t.integer  "power"
    t.integer  "max_pp"
    t.string   "element_type", limit: 45
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "trainer_pokemons", force: :cascade do |t|
    t.integer  "trainer_id"
    t.integer  "pokemon_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["pokemon_id"], name: "index_trainer_pokemons_on_pokemon_id", using: :btree
    t.index ["trainer_id"], name: "index_trainer_pokemons_on_trainer_id", using: :btree
  end

  create_table "trainers", force: :cascade do |t|
    t.string   "name",       limit: 45
    t.string   "email",      limit: 45
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  add_foreign_key "pokemon_battle_logs", "pokemon_battles"
  add_foreign_key "pokemon_battle_logs", "skills"
  add_foreign_key "pokemon_skills", "pokemons"
  add_foreign_key "pokemon_skills", "skills"
  add_foreign_key "pokemons", "pokedexes"
  add_foreign_key "trainer_pokemons", "pokemons"
  add_foreign_key "trainer_pokemons", "trainers"
end
