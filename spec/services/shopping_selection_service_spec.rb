require 'spec_helper'

RSpec.describe ShoppingListService, focus: true do
  subject(:shopping_selection) { ShoppingSelectionService.call(errand) }

  let(:sale) { Sale.where(user: user).first }
  let(:user) { User.find_by(email: 'fake') }
  let(:budget) { Budget.create!(users: [user], duration: 1.week, total: 5_000_000)  }
  let(:fake_package) { Package.create!(product: fake_product, unit_measurement: 7, unit_count: 3) }
  let(:fake_product) { Product.create!(item: fake_item, brand: brand, measurement_units: 1) }
  let(:fake_store) { Store.create!(name: 'fake store', location: 'fake location') }
  let(:fake_item) { Item.create!(name: 'fake item name', department: dept) }
  let(:dept) { Department.create!(name: 'fake') }
  let(:brand) { Brand.create!(name: 'generic') }
  let(:errand) { Errand.create!(item: fake_item, budgets: [budget], **errand_opts) }

  let(:errand_opts) do
    { store: Store.last, estimated_serving_count: 1, estimated_serving_measurement: 10, maximum_spend: 100 }
  end

  before do
    user = User.create!(email: 'fake', password: 'fake')

    Sale.create!(store: fake_store, user: user, package: fake_package, price: 21, date: Date.current)
  end

  context 'when the cost for the preferred brand exceeds the budgeted amount' do
    # subject { shopping_selection.best_matching_deal.brand }

    # let(:particular_brand)  { Brand.create!(name: 'fake particular brand') }
    # let(:another_budget)    { Budget.create!(users: [User.last], duration: 2.week, total: 3_123_654)  }
    # let(:alternate_item)    { Item.find_by(name: 'fake item name') }
    # let(:alternate_product) { Product.create!(item: alternate_item, brand: particular_brand, measurement_units: 1) }
    # let(:alternate_package) { Package.create!(product: alternate_product, unit_measurement: 7, unit_count: 3) }

    # before do
    #   Errand.create!(item: alternate_item, brand: particular_brand, budgets: [another_budget], **errand_opts)
    #   Sale.create!(store: fake_store, user: user, package: fake_package, price: 21, date: Date.current)
    # end

    # context 'where the alternate brand is NOT a better deal' do
    #   let(:generic_brand) { Brand.find_by(name: 'generic') }

    #   before do
    #     Sale.create!(store: fake_store, user: user, package: alternate_package, price: 210, date: Date.current)
    #   end

    #   it { is_expected.to eq(generic_brand) }
    # end
  end

  context 'when filtering by store' do
    pending
  end

  context 'when filtering by product' do
    pending
  end

  context 'when there are no sales for the selected item' do
    subject { ShoppingSelectionService.call(errand) }

    let(:errand) { Errand.create!(item: another_fake_item, budgets: [budget], **errand_opts) }
    let(:another_fake_item) { Item.create!(name: 'a different fake item name', department: dept) }

    it { is_expected.to be_nil }
  end

  context 'when creating an errand for an alternate brand' do
    subject { shopping_selection.best_matching_deal.brand }

    let(:particular_brand)  { Brand.create!(name: 'fake particular brand') }
    let(:another_budget)    { Budget.create!(users: [User.last], duration: 2.week, total: 3_123_654)  }
    let(:alternate_item)    { Item.find_by(name: 'fake item name') }
    let(:alternate_product) { Product.create!(item: alternate_item, brand: particular_brand, measurement_units: 1) }
    let(:alternate_package) { Package.create!(product: alternate_product, unit_measurement: 7, unit_count: 3) }

    before do
      Errand.create!(item: alternate_item, brand: particular_brand, budgets: [another_budget], **errand_opts)
      Sale.create!(store: fake_store, user: user, package: fake_package, price: 21, date: Date.current)
    end

    context 'where the alternate brand is a better deal' do
      before do
        Sale.create!(store: fake_store, user: user, package: alternate_package, price: 2.1, date: Date.current)
      end

      it { is_expected.to eq(particular_brand) }
    end

    context 'where the alternate brand is NOT a better deal' do
      let(:generic_brand) { Brand.find_by(name: 'generic') }

      before do
        Sale.create!(store: fake_store, user: user, package: alternate_package, price: 210, date: Date.current)
      end

      it { is_expected.to eq(generic_brand) }
    end
  end
end