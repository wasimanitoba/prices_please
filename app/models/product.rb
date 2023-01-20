# frozen_string_literal: true

# == Schema Information
#
# Table name: products
#
#  id                    :bigint           not null, primary key
#  filterable_attributes :string
#  measurement_units     :integer          not null
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  brand_id              :bigint           not null
#  item_id               :bigint           not null
#
# Indexes
#
#  index_products_on_brand_id  (brand_id)
#  index_products_on_item_id   (item_id)
#
# Foreign Keys
#
#  fk_rails_...  (brand_id => brands.id)
#  fk_rails_...  (item_id => items.id)
#
class Product < ApplicationRecord
  include Shoppable

  enum measurement_units: %i[ weight volume ]

  validates :measurement_units, presence: true

  serialize :filterable_attributes, Hash

  # Get the best SALE price for any PACKAGE for this PRODUCT for the given STORE
  def best_deal_for_store(store); end

  belongs_to :item
  belongs_to :brand, optional: true
  has_many :packages
  has_many :sales, through: :packages, inverse_of: :product
  accepts_nested_attributes_for :item

  def measurement_unit
    measurement_units == 'weight' ? 'kilogram' : 'litre'
  end
end
