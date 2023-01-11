# frozen_string_literal: true

# == Schema Information
#
# Table name: packages
#
#  id                :bigint           not null, primary key
#  total_measurement :decimal(, )      not null
#  unit_count        :integer          default(1), not null
#  unit_measurement  :decimal(, )      not null
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

  # The units set by user at time of submitting data
  enum measurement_units: { weight: 0, volume: 1 }

  validates :unit_measurement, presence: true

  has_many :sales
  belongs_to :product
  belongs_to :item, optional: true, inverse_of: :packages
  accepts_nested_attributes_for :item, :product

  before_save do
    self.total_measurement = unit_measurement * unit_count
  end

  def amount(qty = 1)
    number_to_human(measurement * qty, units: product.measurement_units)
  end

  # Get the best SALE price for this PACKAGE for the given STORE
  def best_deal_for_store(store); end
end
