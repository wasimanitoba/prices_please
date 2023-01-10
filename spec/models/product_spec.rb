# frozen_string_literal: true

# == Schema Information
#
# Table name: products
#
#  id                    :bigint           not null, primary key
#  filterable_attributes :string
#  measurement_units     :integer
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
require 'rails_helper'

RSpec.describe Product, type: :model do
  describe '#best_deal_for_store' do; end

  describe '#best_deal' do; end

  describe '#cheapest_supplier' do; end
  describe '#monthly_average_price' do; end
  describe '#yearly_average_price' do; end
  describe '#prices_by_month' do; end
end
