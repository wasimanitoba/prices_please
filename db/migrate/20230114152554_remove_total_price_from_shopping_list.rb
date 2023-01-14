class RemoveTotalPriceFromShoppingList < ActiveRecord::Migration[7.0]
  def change
    remove_column :shopping_lists, :total_price, :decimal
  end
end
