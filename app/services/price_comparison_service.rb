# frozen_string_literal: true

class PriceComparisonService
  def initialize(wishlist_hash, _user)
    @wishlist_hash = wishlist_hash
  end

  def call
    comparison_values = Store.all.map.to_h do |store|
      [store.name, { total_basket_measurement: 0, total_basket_price: 0 }]
    end

    shopping_list = wishlist_hash.map do |grocery|
      store_deal = grocery.best_deal_for_store(store)

      if store_deal
        # store_deals[store.name][:amount]      += (store_deal.amount(:numeric) * qty)
        store_deals[store.name][:amount]      += (store_deal.amount_numeric * qty)
        store_deals[store.name][:total_price] += (store_deal.price * qty)
      else
        store_deals[store.name][:amount] = -100_000_000
        # invalidate the entire count if we can't find a total for this store
      end

      filtered_deals    = store_deals.filter { |_store, totals| totals[:amount] if totals[:amount] >= 0.01 }
      minimums          = filtered_deals.sort_by { |_store, deal| deal[:amount] / deal[:total_price] }
      minimum           = minimums.last

      @best_basket_price = minimum&.last&.fetch(:total_price, 0)
      @best_basket_amount = minimum&.last&.fetch(:amount, 0)

      Errand.new
    end

    @budget = Budget.create!(user: user, errands: shopping_list)
  end
end
