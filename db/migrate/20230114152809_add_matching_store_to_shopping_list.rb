class AddMatchingStoreToShoppingList < ActiveRecord::Migration[7.0]
  def change
    drop_table :shopping_selections

    create_table "shopping_lists", force: :true do |t|
      t.decimal "cheapest_total"
      t.decimal "best_value_total"
      t.references "cheapest_store", null: true
      t.references "best_value_store", null: false
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
    end

    add_foreign_key :shopping_lists, :stores, column: 'best_value_store_id'
    add_foreign_key :shopping_lists, :stores, column: 'cheapest_store_id'

    create_table "shopping_selections", force: :cascade do |t|
      t.bigint "best_matching_deal_id", null: false
      t.bigint "better_alternate_deal_id"
      t.bigint "shopping_list_id", null: false
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.index ["best_matching_deal_id"], name: "index_shopping_selections_on_best_matching_deal_id"
      t.index ["better_alternate_deal_id"], name: "index_shopping_selections_on_better_alternate_deal_id"
      t.index ["shopping_list_id"], name: "index_shopping_selections_on_shopping_list_id"
    end
  end
end
