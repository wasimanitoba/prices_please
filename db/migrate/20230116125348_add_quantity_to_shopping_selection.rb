class AddQuantityToShoppingSelection < ActiveRecord::Migration[7.0]
  def change
    add_column :shopping_selections, :quantity, :integer
  end
end
