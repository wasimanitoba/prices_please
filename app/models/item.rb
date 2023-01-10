# frozen_string_literal: true

# == Schema Information
#
# Table name: items
#
#  id            :bigint           not null, primary key
#  name          :string
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

  belongs_to :department

  before_save do
    self.name = name.downcase
  end

  def sales
    # packages.flat_map(&:sales)
    Sale.where(package: packages)
  end

  # Get the best SALE price for any PACKAGE of any PRODUCT for this ITEM for the given STORE
  def best_deal_for_store(store); end

  # Get the best SALE price for any PACKAGE of any PRODUCT for this ITEM for ANY store
  def best_deal
    sales.order(price: :asc).limit(1).first
  end

  def best_supplier
    best_deal.store
  end
end
