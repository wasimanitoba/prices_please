# frozen_string_literal: true

# == Schema Information
#
# Table name: packages
#
#  id                :bigint           not null, primary key
#  total_measurement :decimal(, )
#  unit_count        :integer          default(1), not null
#  unit_measurement  :decimal(, )
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  product_id        :bigint           not null
#
# Indexes
#
#  index_packages_on_product_id  (product_id)
#
# Foreign Keys
#
#  fk_rails_...  (product_id => products.id)
#
class Package < ApplicationRecord
  include ActionView::Helpers::NumberHelper
  include Shoppable

  has_many :sales
  belongs_to :product
  belongs_to :item, optional: true, inverse_of: :packages
  accepts_nested_attributes_for :product

  delegate :item, to: :product
  delegate :brand, to: :product
  delegate :measurement_units, to: :product

  before_save do
    self.total_measurement = if unit_measurement.present?
                              unit_measurement * unit_count
                             else
                              'each'
                             end
  end

  def to_s
    "#{amount} #{brand} #{item}"
  end

  def amount(qty = 1)
    return unless unit_measurement.present?

    number_to_human(unit_measurement * qty, units: product.measurement_units)
  end

  # Get the best SALE price for this PACKAGE for the given STORE
  def best_deal_for_store(store)
    Sale.where(store: store).find_cheapest_sale_for_package(self)
  end
end
