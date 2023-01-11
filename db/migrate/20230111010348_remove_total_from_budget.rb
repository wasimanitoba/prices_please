class RemoveTotalFromBudget < ActiveRecord::Migration[7.0]
  def change
    remove_column :budgets, :total, :string
  end
end
