
# frozen_string_literal: true

class Shopping::GrocerySelector < ApplicationService
  def initialize(errand)
    @errand = errand

    @shopping_selection = ShoppingSelection.new()

    @matching_sale = if errand.store.present?
                        errand.item.best_deal_for_store(errand.store)
                      # elsif errand.product.present?
                        # errand.item.best_deal_for_product(errand.product)
                      elsif errand.brand.present?
                        errand.item.best_deal_for_brand(errand.brand)
                      end

    # If a matching sale isn't present, we'll perform on operations on the best available deal for this item.
    @fallback_selection = @matching_sale || errand.item.best_deal

    return if @fallback_selection.blank?

    estimated_total_measurement = @errand.estimated_serving_count * @errand.estimated_serving_measurement

    @shopping_selection.quantity = if @errand.quantity.present?
                                    @errand.quantity
                                   elsif @fallback_selection.package.total_measurement >= estimated_total_measurement
                                    1
                                   else
                                    (estimated_total_measurement / @fallback_selection.package.total_measurement).to_i
                                   end
  end

  def call
    return if @fallback_selection.blank?

    savings = @errand.maximum_spend - (@fallback_selection.price * @shopping_selection.quantity)
    return if savings < 0

    @shopping_selection.best_matching_deal = @matching_sale
    # The fallback selection will be the matching sale if present
    @shopping_selection.better_alternate_deal = @fallback_selection unless @matching_sale == @fallback_selection

    @shopping_selection
  end

  def calculated_measurement
    @calculated_measurement ||= @fallback_selection.unit_cost * @shopping_selection.quantity
  end

  def calculated_price
    @calculated_price ||= @fallback_selection.price * @shopping_selection.quantity
  end
end
