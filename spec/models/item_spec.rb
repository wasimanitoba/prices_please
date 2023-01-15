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
require 'rails_helper'

RSpec.describe Item, type: :model, focus: true do
  subject(:fake_item) { Item.find_by(name: 'fake item name') }

  before do
    user         = User.create!(email: 'test@test.ca', password: 'fake password')
    fake_item    = Item.create!(name: 'fake item name', department: Department.create!(name: 'fake dept'))
    fake_product = Product.create!(item: fake_item, brand: Brand.create!(name: 'generic'), measurement_units: 1)
    fake_package = Package.create!(product: fake_product, unit_measurement: 1)

    cheap     = { name: 'cheap store', location: 'underprivileged neighbourhood', price: 2.5 }
    expensive = { name: 'pricey store', location: 'underprivileged neighbourhood', price: 1000 }
    bulk      = { name: 'bulk store', location: 'swanky neighbourhood', price: 100 }

    [cheap, expensive, bulk].each do |opts|
      store = Store.create!(name: opts.delete(:name), location: opts.delete(:location))

      opts.merge!({ package: fake_package, store: store, quantity: 1, date: Date.current, user: user })

      (1..10).each { |_i| Sale.create!(**opts) }
    end
  end

  it { is_expected.to have_many(:sales).through(:products).through(:packages) }

  describe '#sales' do
    subject { fake_item.sales.size }

    it { is_expected.to eq(30) }
  end

  describe '#best_deal' do
    subject { fake_item.best_deal }

    it { is_expected.to have_attributes(price: 2.5) }
  end

  describe '#best_deal_for_store' do
    subject { fake_item.best_deal_for_store(bulk_store) }

    let(:bulk_store) { Store.find_by(name: 'bulk store') }

    it { is_expected.to have_attributes(price: 100) }
  end

  describe '#best_supplier' do
    subject { fake_item.best_supplier }

    let(:the_cheap_store) { Store.find_by(name: 'cheap store') }

    it { is_expected.to eq(the_cheap_store) }
  end

  describe '#cheapest_supplier' do; end
  describe '#monthly_average_price' do; end
  describe '#yearly_average_price' do; end
  describe '#prices_by_month' do; end
end
