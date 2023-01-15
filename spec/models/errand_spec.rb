# frozen_string_literal: true

# == Schema Information
#
# Table name: errands
#
#  id                            :bigint           not null, primary key
#  estimated_serving_count       :integer          not null
#  estimated_serving_measurement :decimal(, )      not null
#  maximum_spend                 :decimal(, )      not null
#  quantity                      :integer          default(1)
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
require 'rails_helper'

RSpec.describe Errand, type: :model, focus: true do
  let(:users)  { [User.create!(email: 'fake', password: 'fake')] }
  let(:dept)   { Department.create!(name: 'fake') }
  let(:budget) { Budget.create!(users: users, duration: 1.week, total: 5_000_000) }
  let(:item)   { Item.create!(name: 'fake', department: dept) }
  let(:errand_opts) { { estimated_serving_count: 1, estimated_serving_measurement: 10, maximum_spend: 100 } }

  describe '.create!' do
    subject(:errand) { Errand.create!(item: item, budgets: [budget], **errand_opts) }

    it { is_expected.to have_many(:budgets).through(:budgets_errands) }
  end
end
