# frozen_string_literal: true
class ListGeneratorService < ApplicationService
  def initialize(budget, user)
    @budget = budget
    @user   = user

    @shopping_list = ShoppingList.new()
    @store_totals = Store.all.map.to_h { |store| [store.id, { total_price: 0, value_per_dollar: 0 }] }
  end

  def call
    @budget.errands.each do |errand|
      shopping_selector = GrocerySelectionService.new(errand)

      @store_totals[errand.store.id][:total_price] += shopping_selector.calculated_price
      @store_totals[errand.store.id][:value_per_dollar] += shopping_selector.calculated_measurement

      @shopping_list.shopping_selections << shopping_selector.call
    end

    @store_totals = @store_totals.filter { |store, hsh| hsh[:total_price] < @budget.total }
    return if @store_totals.empty?

    set_store_values!(:total_price, :cheapest)

    set_store_values!(:value_per_dollar, :best_value)

    @shopping_list
  end

  private

    def set_store_values!(key, selected_attribute_name)
      store_details = @store_totals.sort_by { |_store, totals| totals[key] }.last

      @shopping_list.send("#{selected_attribute_name}_store=", Store.find(store_details.first))

      @shopping_list.send("#{selected_attribute_name}_total=", store_details.last[key])
    end
end