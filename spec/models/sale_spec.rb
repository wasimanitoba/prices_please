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
require 'rails_helper'

RSpec.describe Sale, type: :model, focus: true do
  subject(:sale) { Sale.create!(**sale_params) }

  let(:sale_params)  { { store: fake_store, user: user, package: fake_package, price: 21, date: Date.current } }

  let(:fake_package) { Package.create!(product: fake_product, unit_measurement: 7, unit_count: 3) }
  let(:fake_store)   { Store.create!(name: 'fake store', location: 'fake location') }

  let(:user)         { User.create!(email: 'test@test.ca', password: 'fake password') }
  let(:fake_item)    { Item.create!(name: 'fake item name', department: Department.create!(name: 'fake dept')) }
  let(:fake_product) { Product.create!(item: fake_item, brand: Brand.create!(name: 'generic'), measurement_units: 1) }

  describe '#unit_cost' do
    subject { sale.unit_cost }

    it { is_expected.to eq(1.to_f) }

    context 'when a non-default quantity is manually set' do
      let(:sale) { Sale.create!(**sale_params.merge({ quantity: 3 })) }

      it { is_expected.to eq(3.to_f) }
    end

    context 'with a negative value entered as price' do
      let(:sale) { Sale.create(**sale_params.merge({ price: -1 })) }

      it { expect { sale.save! }.to raise_error(ActiveRecord::RecordInvalid) }
    end
  end
end
