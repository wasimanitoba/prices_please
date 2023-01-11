# frozen_string_literal: true

module Shoppable
  extend ActiveSupport::Concern

  included do
    # returns Array<Float> - An array of prices for the previous year
    def monthly_prices
      DateTime::ABBR_MONTHNAMES.compact.map do |month|
        prices_for_the_month = @price_history_by_month[month]

        next if prices_for_the_month.blank?

        prices_for_the_month.sum(&:price) / prices_for_the_month.size
      end
    end

    # Returns Hash<Integer, Array> - a hash indexed by the month name where the values are arrays of prices
    def price_history_by_month
      @price_history_by_month ||= sales.where(date: 1.year.ago..Date.current).group_by do |sale|
        DateTime::ABBR_MONTHNAMES.compact[sale.date.month - 1]
      end
    end
  end

  class_methods do
    def js_columns; end
  end
end
