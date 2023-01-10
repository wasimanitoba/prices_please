# frozen_string_literal: true

# == Schema Information
#
# Table name: packages
#
#  id                :bigint           not null, primary key
#  total_measurement :decimal(, )
#  unit_count        :integer
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
  include Shoppable

  before_save do
    self.total_measurement = unit_measurement * unit_count
  end

  validates :unit_measurement, presence: true

  belongs_to :product
  belongs_to :item, inverse_of: :packages, optional: true
  accepts_nested_attributes_for :item

  has_many :sales

  # Get the best SALE price for this PACKAGE for the given STORE
  def best_deal_for_store(store); end

  # The units set by user at time of submitting data
  enum measurement_units: { weight: 0, volume: 1 }

  def measurement_unit
    measurement_units == 'weight' ? 'kilogram' : 'litre'
  end
end
