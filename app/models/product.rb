# == Schema Information
#
# Table name: products
#
#  id                    :bigint           not null, primary key
#  brand                 :string
#  filterable_attributes :string
#  measurement_units     :integer
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  item_id               :bigint           not null
#
# Indexes
#
#  index_products_on_item_id  (item_id)
#
# Foreign Keys
#
#  fk_rails_...  (item_id => items.id)
#
class Product < ApplicationRecord
  belongs_to :item
end
