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

  context 'when creating an errand for a particular brand' do
    subject { shopping_selection.best_matching_deal.brand }

    let(:errand) { Errand.create!(item: fake_item, brand: alternate_brand, budgets: [budget], **errand_opts) }
    let(:alternate_brand) { Brand.create!(name: 'fake alternate brand') }
    let(:alternate_product) { Product.create!(item: fake_item, brand: alternate_brand, measurement_units: 1) }
    let(:alternate_package) { Package.create!(product: alternate_product, unit_measurement: 7, unit_count: 3) }
    let(:particular_brand)  { Brand.find_by(name: 'generic') }

    before do
      Sale.create!(store: fake_store, user: user, package: alternate_package, price: 21, date: Date.current)
    end

    it { is_expected.to eq(particular_brand) }

    context 'where the cost for the preferred brand exceeds the budgeted amount' do
      subject { shopping_selection }

      let(:errand_opts) do
        { store: Store.last, estimated_serving_count: 1, estimated_serving_measurement: 10, maximum_spend: 15 }
      end

      it { is_expected.to be_nil }

      context 'with an alternate brand at a better price' do
        subject { shopping_selection.best_matching_deal.brand }

        before do
          Sale.create!(store: fake_store, user: user, package: alternate_package, price: 2.1, date: Date.current)
        end

        it { is_expected.to eq(alternate_brand) }
      end

      context 'with an alternate brand at a worse price' do
        subject { shopping_selection }

        before do
          Sale.create!(store: fake_store, user: user, package: alternate_package, price: 210, date: Date.current)
        end

        it { is_expected.to be_nil }
      end
    end
  end
end