# frozen_string_literal: true

# == Schema Information
#
# Table name: errands
#
#  id                            :bigint           not null, primary key
#  estimated_serving_count       :integer          not null
#  estimated_serving_measurement :decimal(, )      not null
#  maximum_spend                 :decimal(, )
#  quantity                      :integer
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#  brand_id                      :bigint
#  item_id                       :bigint           not null
#  product_id                    :bigint
#  store_id                      :bigint
#
# Indexes
#
#  index_errands_on_brand_id    (brand_id)
#  index_errands_on_item_id     (item_id)
#  index_errands_on_product_id  (product_id)
#  index_errands_on_store_id    (store_id)
#
# Foreign Keys
#
#  fk_rails_...  (brand_id => brands.id)
#  fk_rails_...  (item_id => items.id)
#  fk_rails_...  (product_id => products.id)
#  fk_rails_...  (store_id => stores.id)
#
class Errand < ApplicationRecord
  validates :maximum_spend, presence: true
  validates :estimated_serving_count, presence: true
  validates :estimated_serving_measurement, presence: true

  belongs_to :brand, optional: true
  belongs_to :store, optional: true
  belongs_to :product, optional: true
  has_many :budgets_errands
  has_many :budgets, through: :budgets_errands
  belongs_to :item
end
