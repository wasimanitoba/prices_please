# frozen_string_literal: true

# == Schema Information
#
# Table name: sales
#
#  id         :bigint           not null, primary key
#  date       :date             not null
#  price      :decimal(, )      not null
#  quantity   :integer          default(1), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  package_id :bigint           not null
#  store_id   :bigint           not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_sales_on_package_id  (package_id)
#  index_sales_on_store_id    (store_id)
#  index_sales_on_user_id     (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (package_id => packages.id)
#  fk_rails_...  (store_id => stores.id)
#  fk_rails_...  (user_id => users.id)
#
class Sale < ApplicationRecord
  validates :price, presence: true, numericality: { greater_than: 0 }

  has_many :shopping_selections, inverse_of: :best_matching_deal
  has_many :shopping_selections, inverse_of: :better_alternate_deal

  belongs_to :store
  belongs_to :user
  belongs_to :package
  belongs_to :product, optional: true, inverse_of: :sale
  belongs_to :item, optional: true, inverse_of: :sale
  accepts_nested_attributes_for :item, :package

  scope :with_packages, -> { joins(:package) }
  scope :with_package, -> (sought_package) { with_packages.where(packages: sought_package ) }

  scope :with_products, -> { joins(package: :product) }
  scope :with_product, -> (sought_product) { with_products.where(packages: { products: sought_product }) }

  scope :with_items, -> { joins(package: { product: :item }) }
  scope :with_item, -> (sought_item) { with_items.where(packages: { products: { items: sought_item } }) }

  def total_measurement
    quantity * package.unit_count * package.unit_measurement
  end

  def unit_cost
    total_measurement.to_f / price
  end

  def self.find_cheapest_sale_for_package(sought_package)
    with_package(sought_package).order(:price).limit(1).first
  end

  def self.find_cheapest_sale_for_product(sought_product)
    with_product(sought_product).order(:price).limit(1).first
  end

  def self.find_cheapest_sale_for_item(sought_item)
    with_item(sought_item).order(:price).limit(1).first
  end
end
