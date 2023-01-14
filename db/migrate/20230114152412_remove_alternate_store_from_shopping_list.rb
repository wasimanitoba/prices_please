class RemoveAlternateStoreFromShoppingList < ActiveRecord::Migration[7.0]
  def change
    remove_reference :shopping_lists, :alternate_store
    remove_reference :shopping_lists, :recommended_store
  end
end
