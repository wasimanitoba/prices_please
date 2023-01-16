require 'spec_helper'

RSpec.describe GrocerySelectionService, focus: true do
  subject(:shopping_selection) { GrocerySelectionService.call(errand) }

  let(:sale) { Sale.where(user: user).first }
  let(:user) { User.find_by(email: 'fake') }
  let(:budget) { Budget.create!(users: [user], duration: 1.week, total: 5_000_000)  }
  let(:fake_package) { Package.create!(product: fake_product, unit_measurement: 7, unit_count: 3) }
  let(:fake_product) { Product.create!(item: fake_item, brand: particular_brand, measurement_units: 1) }
  let(:fake_store) { Store.create!(name: 'fake store', location: 'fake location') }
  let(:fake_item) { Item.create!(name: 'fake item name', department: dept) }
  let(:dept) { Department.create!(name: 'fake') }
  let(:particular_brand) { Brand.create!(name: 'generic') }
  let(:errand) { Errand.create!(item: fake_item, budgets: [budget], **errand_opts) }

  let(:errand_opts) do
    { estimated_serving_count: 1, estimated_serving_measurement: 10, maximum_spend: 100 }
  end

  before do
    user = User.create!(email: 'fake', password: 'fake')

    Sale.create!(store: fake_store, user: user, package: fake_package, price: 21, date: Date.current)
  end

  it { is_expected.to be_an_instance_of(ShoppingSelection) }

  context 'when filtering by store' do
    subject { shopping_selection.best_matching_deal }

    let(:preferred_store) { Store.create!(name: 'preferred store', location: 'somewhere') }
    let(:errand_opts) do
      { store: preferred_store, estimated_serving_count: 1, estimated_serving_measurement: 10, maximum_spend: 100 }
    end

    before { Sale.create!(store: preferred_store, user: user, package: fake_package, price: 21, date: Date.current)  }

    it { is_expected.to have_attributes(store: preferred_store) }
  end

  context 'when there are no sales for the selected item' do
    subject { GrocerySelectionService.call(errand) }

    let(:errand) { Errand.create!(item: another_fake_item, budgets: [budget], **errand_opts) }
    let(:another_fake_item) { Item.create!(name: 'a different fake item name', department: dept) }

    it { is_expected.to be_nil }
  end

  context 'when creating an errand for a particular brand' do
    subject { shopping_selection&.best_matching_deal }

    let(:particular_brand)  { Brand.create!(name: 'particular brand') }
    let(:alternate_brand)   { Brand.create!(name: 'fake alternate brand') }
    let(:alternate_product) { Product.create!(item: fake_item, brand: alternate_brand, measurement_units: 1) }
    let(:alternate_package) { Package.create!(product: alternate_product, unit_measurement: 7, unit_count: 3) }

    let(:errand)            { Errand.create!(item: fake_item, brand: particular_brand, budgets: [budget], **errand_opts) }

    it { is_expected.to have_attributes(brand: particular_brand) }

    context 'where the cost for the preferred brand exceeds the budgeted amount' do
      let(:errand_opts) do
        { store: Store.last, estimated_serving_count: 1, estimated_serving_measurement: 10, maximum_spend: 15 }
      end

      before do
        Sale.create!(store: fake_store, user: user, package: alternate_package, price: 21, date: Date.current)
      end

      it { is_expected.to be_nil }

      context 'with an alternate brand at a better price' do
        subject { shopping_selection.best_matching_deal }

        before do
          Sale.create!(store: fake_store, user: user, package: alternate_package, price: 2.1, date: Date.current)
        end

        it { is_expected.to have_attributes(brand: alternate_brand) }
      end

      context 'with an alternate brand at a worse price' do
        before do
          Sale.create!(store: fake_store, user: user, package: alternate_package, price: 210, date: Date.current)
        end

        it { is_expected.to be_nil }
      end
    end
  end

  context 'when multiple packages are needed for the desired quantity of servings' do
    let(:errand_opts) do
      { estimated_serving_count: 1, estimated_serving_measurement: 210, maximum_spend: 1000 }
    end

    it { is_expected.to have_attributes(quantity: 10) }

    context 'with an insufficient budget' do
      let(:errand_opts) do
        { estimated_serving_count: 1, estimated_serving_measurement: 210, maximum_spend: 100 }
      end

      it { is_expected.to be_nil }
    end
  end
end