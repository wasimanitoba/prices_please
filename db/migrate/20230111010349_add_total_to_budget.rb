# frozen_string_literal: true

class AddTotalToBudget < ActiveRecord::Migration[7.0]
  def change
    add_column :budgets, :total, :decimal
  end
end
