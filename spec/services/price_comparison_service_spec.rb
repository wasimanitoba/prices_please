require 'spec_helper'

RSpec.describe PriceComparisonService do
  subject(:list) { PriceComparisonService.call(budget, User.last) }

  let(:sale) { Sale.where(user: user).first }
  let(:user) { User.find_by(email: 'fake') }
  let(:budget) { Budget.create!(users: [user], duration: 1.week, total: 5_000_000)  }

  let(:errand_opts) do
    { store: Store.last, estimated_serving_count: 1, estimated_serving_measurement: 10, maximum_spend: 100 }
  end

  before do
    user = User.create!(email: 'fake', password: 'fake')

    dept = Department.create!(name: 'fake')
    brand = Brand.create!(name: 'generic')
    fake_item = Item.create!(name: 'fake item name', department: dept)
    fake_store = Store.create!(name: 'fake store', location: 'fake location')
    fake_product = Product.create!(item: fake_item, brand: brand, measurement_units: 1)
    fake_package = Package.create!(product: fake_product, unit_measurement: 7, unit_count: 3)

    Sale.create! store: fake_store, user: user, package: fake_package, price: 21, date: Date.current
    Errand.create!(item: Item.last, budgets: [budget], **errand_opts)
  end

  it { is_expected.not_to be_empty }
  it { is_expected.to be_an_instance_of(ShoppingList) }

  context 'when there are no sales for the selected item' do
    subject(:list) { PriceComparisonService.call(another_budget, User.last) }

    let(:another_budget) { Budget.create!(users: [User.last], duration: 2.week, total: 3_123_654)  }

    it { is_expected.to be_empty }
  end

  context 'when creating an errand for an alternate brand' do
    subject { list.map { |selection| selection.best_matching_deal.brand } }

    let(:list) { PriceComparisonService.call(another_budget, User.last).shopping_selections }
    let(:particular_brand)  { Brand.create!(name: 'fake particular brand') }
    let(:another_budget) { Budget.create!(users: [User.last], duration: 2.week, total: 3_123_654)  }
    let(:alternate_item) { Item.find_by(name: 'fake item name') }
    let(:alternate_product) { Product.create!(item: alternate_item, brand: particular_brand, measurement_units: 1) }
    let(:alternate_package) { Package.create!(product: alternate_product, unit_measurement: 7, unit_count: 3) }

    before do
      Errand.create!(item: alternate_item, brand: particular_brand, budgets: [another_budget], **errand_opts)
    end

    context 'where the alternate brand is a better deal' do
      before do
        Sale.create!(store: Store.last, user: user, package: alternate_package, price: 2.1, date: Date.current)
      end

      it { is_expected.to contain_exactly(particular_brand) }
    end

    context 'where the alternate brand is not a better deal' do
      let(:generic_brand) { Brand.find_by(name: 'generic') }

      before do
        Sale.create!(store: Store.last, user: user, package: alternate_package, price: 210, date: Date.current)
      end

      it { is_expected.to contain_exactly(generic_brand) }
    end
  end
end