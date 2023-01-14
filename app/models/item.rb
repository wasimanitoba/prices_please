# frozen_string_literal: true

# == Schema Information
#
# Table name: items
#
#  id            :bigint           not null, primary key
#  name          :string           not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  department_id :bigint           not null
#
# Indexes
#
#  index_items_on_department_id  (department_id)
#
# Foreign Keys
#
#  fk_rails_...  (department_id => departments.id)
#
class Item < ApplicationRecord
  include Shoppable

  validates :name, presence: true
  has_many :products
  has_many :packages, through: :products, inverse_of: :item
  has_many :sales, through: :packages, inverse_of: :item
  accepts_nested_attributes_for :sales, :packages, :products

  scope :with_sales, -> { sales.order(price: :asc) }
  scope :with_store_sales, -> (store) { with_sales.where(store: store) }

  belongs_to :department

  before_save do
    self.name = name.downcase
  end

  # Get the best SALE price for any PACKAGE of any PRODUCT for this ITEM for ANY store
  def best_deal
    Sale.find_cheapest_sale_for_item(self)
  end

  def best_deal_for_store(store)
    Sale.where(store: store).find_cheapest_sale_for_item(self)
  end

  def best_supplier
    best_deal.store
  end
end
