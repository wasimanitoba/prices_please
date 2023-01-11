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
  belongs_to :store
  belongs_to :user
  belongs_to :package
  belongs_to :product, optional: true, inverse_of: :sale
  belongs_to :item, optional: true, inverse_of: :sale
  accepts_nested_attributes_for :item, :package

  def unit_cost
    total_measurement = quantity * package.unit_count * package.unit_measurement

    total_measurement.to_f / price
  end
end
