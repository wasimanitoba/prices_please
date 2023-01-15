require 'spec_helper'

RSpec.describe ShoppingListService, focus: true do
  subject(:list) { ShoppingListService.call(budget, User.last) }

  let(:sale) { Sale.where(user: user).first }
  let(:user) { User.find_by(email: 'fake') }
  let(:budget) { Budget.create!(users: [user], duration: 1.week, total: 5_000_000)  }
  let(:fake_package) { Package.create!(product: fake_product, unit_measurement: 7, unit_count: 3) }
  let(:fake_product) { Product.create!(item: fake_item, brand: brand, measurement_units: 1) }
  let(:fake_store) { Store.create!(name: 'fake store', location: 'fake location') }
  let(:fake_item) { Item.create!(name: 'fake item name', department: dept) }
  let(:dept) { Department.create!(name: 'fake') }
  let(:brand) { Brand.create!(name: 'generic') }

  let(:errand_opts) do
    { store: Store.last, estimated_serving_count: 1, estimated_serving_measurement: 10, maximum_spend: 100 }
  end

  before do
    user = User.create!(email: 'fake', password: 'fake')

    Sale.create!(store: fake_store, user: user, package: fake_package, price: 21, date: Date.current)
    Errand.create!(item: fake_item, budgets: [budget], **errand_opts)
  end

  it { is_expected.not_to be_empty }
  it { is_expected.to be_an_instance_of(ShoppingList) }

  describe '#cheapest_total' do
    subject { list.cheapest_total }

    it { is_expected.to eq(21) }
  end

  context 'with an empty budget' do
    subject(:list) { ShoppingListService.call(empty_budget, User.last) }

    let(:empty_budget) { Budget.create!(users: [User.last], duration: 2.week, total: 3_123_654)  }

    it { is_expected.to be_empty }
  end

  context 'when multiple packages are needed for the desired quantity of servings' do
    pending
  end
end