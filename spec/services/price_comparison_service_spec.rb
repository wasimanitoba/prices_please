require 'spec_helper'

RSpec.describe PriceComparisonService do
  subject(:list) { PriceComparisonService.call(budget, User.last) }

  let(:sale) { Sale.where(user: User.find_by(email: 'fake')).first }
  let(:budget) { Budget.create!(users: [User.last], duration: 1.week, total: 5_000_000)  }

    before do
      user = User.create!(email: 'fake', password: 'fake')

      dept = Department.create!(name: 'fake')
      brand = Brand.create!(name: 'generic')
      fake_item = Item.create!(name: 'fake item name', department: dept)
      fake_store = Store.create!(name: 'fake store', location: 'fake location')
      fake_product = Product.create!(item: fake_item, brand: brand, measurement_units: 1)
      fake_package = Package.create!(product: fake_product, unit_measurement: 7, unit_count: 3)

      Sale.create! store: fake_store, user: user, package: fake_package, price: 21, date: Date.current
      Errand.create!(item: Item.last, budgets: [budget], store: Store.last)
    end

  it { is_expected.not_to be_empty }
  it { is_expected.to be_an_instance_of(ShoppingList) }

  context 'when there are no sales for the selected item' do
    subject(:list) { PriceComparisonService.call(another_budget, User.last) }

    let(:another_budget) { Budget.create!(users: [User.last], duration: 2.week, total: 3_123_654)  }

    it { is_expected.to be_empty }
  end
end