# == Schema Information
#
# Table name: packages
#
#  id          :bigint           not null, primary key
#  measurement :decimal(, )
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  product_id  :bigint           not null
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
  belongs_to :product
end
