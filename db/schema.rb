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

ActiveRecord::Schema[7.0].define(version: 2023_01_19_004654) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "brands", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "budgets", force: :cascade do |t|
    t.string "duration"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "public", default: false
    t.decimal "total"
  end

  create_table "budgets_errands", id: false, force: :cascade do |t|
    t.bigint "budget_id", null: false
    t.bigint "errand_id", null: false
    t.index ["budget_id", "errand_id"], name: "index_budgets_errands_on_budget_id_and_errand_id"
    t.index ["errand_id", "budget_id"], name: "index_budgets_errands_on_errand_id_and_budget_id"
  end

  create_table "budgets_items", id: false, force: :cascade do |t|
    t.bigint "budget_id", null: false
    t.bigint "item_id", null: false
    t.decimal "maximum_spend"
    t.decimal "estimated_serving_amount"
    t.integer "estimated_serving_count"
    t.index ["budget_id", "item_id"], name: "index_budgets_items_on_budget_id_and_item_id"
    t.index ["item_id", "budget_id"], name: "index_budgets_items_on_item_id_and_budget_id"
  end

  create_table "budgets_users", id: false, force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "budget_id", null: false
    t.index ["budget_id", "user_id"], name: "index_budgets_users_on_budget_id_and_user_id"
    t.index ["user_id", "budget_id"], name: "index_budgets_users_on_user_id_and_budget_id"
  end

  create_table "departments", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "errands", force: :cascade do |t|
    t.decimal "maximum_spend"
    t.bigint "brand_id"
    t.integer "estimated_serving_count", null: false
    t.decimal "estimated_serving_measurement", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "store_id"
    t.bigint "product_id"
    t.bigint "item_id", null: false
    t.integer "quantity"
    t.index ["brand_id"], name: "index_errands_on_brand_id"
    t.index ["item_id"], name: "index_errands_on_item_id"
    t.index ["product_id"], name: "index_errands_on_product_id"
    t.index ["store_id"], name: "index_errands_on_store_id"
  end

  create_table "items", force: :cascade do |t|
    t.string "name", null: false
    t.bigint "department_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["department_id"], name: "index_items_on_department_id"
  end

  create_table "packages", force: :cascade do |t|
    t.decimal "unit_measurement"
    t.bigint "product_id", null: false
    t.integer "unit_count", default: 1
    t.decimal "total_measurement"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id"], name: "index_packages_on_product_id"
  end

  create_table "pipelines", force: :cascade do |t|
    t.string "target", null: false
    t.bigint "department_id", null: false
    t.bigint "store_id", null: false
    t.string "website", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["department_id"], name: "index_pipelines_on_department_id"
    t.index ["store_id"], name: "index_pipelines_on_store_id"
  end

  create_table "products", force: :cascade do |t|
    t.integer "measurement_units", null: false
    t.bigint "item_id", null: false
    t.string "filterable_attributes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "brand_id", null: true
    t.index ["brand_id"], name: "index_products_on_brand_id"
    t.index ["item_id"], name: "index_products_on_item_id"
  end

  create_table "sales", force: :cascade do |t|
    t.decimal "price", null: false
    t.bigint "package_id", null: false
    t.bigint "store_id", null: false
    t.bigint "pipeline_id"
    t.date "date", null: false
    t.string 'details', array: true
    t.integer "quantity", default: 1, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["package_id"], name: "index_sales_on_package_id"
    t.index ["store_id"], name: "index_sales_on_store_id"
    t.index ["pipeline_id"], name: "index_sales_on_pipeline_id"
    t.index ["pipeline_id", "date"], name: "index_sales_on_pipeline_id_and_date"
  end

  create_table "shopping_lists", force: :cascade do |t|
    t.decimal "cheapest_total"
    t.decimal "best_value_total"
    t.bigint "cheapest_store_id"
    t.bigint "best_value_store_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["best_value_store_id"], name: "index_shopping_lists_on_best_value_store_id"
    t.index ["cheapest_store_id"], name: "index_shopping_lists_on_cheapest_store_id"
  end

  create_table "shopping_selections", force: :cascade do |t|
    t.bigint "best_matching_deal_id", null: false
    t.bigint "better_alternate_deal_id"
    t.bigint "shopping_list_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "quantity"
    t.index ["best_matching_deal_id"], name: "index_shopping_selections_on_best_matching_deal_id"
    t.index ["better_alternate_deal_id"], name: "index_shopping_selections_on_better_alternate_deal_id"
    t.index ["shopping_list_id"], name: "index_shopping_selections_on_shopping_list_id"
  end

  create_table "stores", force: :cascade do |t|
    t.string "name", null: false
    t.string "location", null: false
    t.point "coordinates"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", null: false
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "errands", "brands"
  add_foreign_key "errands", "items"
  add_foreign_key "errands", "products"
  add_foreign_key "errands", "stores"
  add_foreign_key "items", "departments"
  add_foreign_key "packages", "products"
  add_foreign_key "pipelines", "departments"
  add_foreign_key "pipelines", "stores"
  add_foreign_key "products", "brands"
  add_foreign_key "products", "items"
  add_foreign_key "sales", "packages"
  add_foreign_key "sales", "stores"
  add_foreign_key "sales", "pipelines"
  add_foreign_key "shopping_lists", "stores", column: "best_value_store_id"
  add_foreign_key "shopping_lists", "stores", column: "cheapest_store_id"
end
