# frozen_string_literal: true

class PriceComparisonService < ApplicationService
  def initialize(budget, user)
    @budget = budget
    @user   = user

    @shopping_list = ShoppingList.new()
    # TODO: Calculate the alternate prices for each store....
    @store_totals = Store.all.map.to_h { |store| [store.id, { total_price: 0, value_per_dollar: 0 }] }
  end

  # TODO: filter by matching amount, matching store, matching budget, product, brand, if such parameters are present
  def call
    @budget.errands.each do |errand|
      matching_sale = errand.item.best_deal_for_store(errand.store)
      next unless matching_sale.present?

      shopping_selection = ShoppingSelection.new()
      shopping_selection.best_matching_deal = matching_sale
      shopping_selection.better_alternate_deal = errand.item.best_deal unless errand.item.best_deal == matching_sale

      errand_quantity = calculated_quantity(errand)
      errand_price = calculated_price(matching_sale, errand_quantity)
      errand_measurement = calculated_measurement(matching_sale, errand_quantity)

      @store_totals[errand.store.id][:total_price] += errand_price
      @store_totals[errand.store.id][:value_per_dollar] += errand_measurement

      @shopping_list.shopping_selections << shopping_selection
    end

    set_store_values!(:total_price, :cheapest)

    set_store_values!(:value_per_dollar, :best_value)

    @shopping_list.save!
    @shopping_list
  end

  private

    def calculated_measurement(matching_sale, errand_quantity)
      matching_sale.unit_cost * errand_quantity
    end

    def calculated_price(matching_sale, errand_quantity)
      matching_sale.price * errand_quantity
    end

    def calculated_quantity(errand)
      errand.quantity * errand.estimated_serving_count * errand.estimated_serving_measurement
    end

    def set_store_values!(key, selected_attribute_name)
      store_details = @store_totals.sort_by { |_store, totals| totals[key] }.first

      @shopping_list.send("#{selected_attribute_name}_store=", Store.find(store_details.first))

      @shopping_list.send("#{selected_attribute_name}_total=", store_details.last[key])
    end
end
