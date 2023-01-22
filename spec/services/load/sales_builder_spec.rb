require 'spec_helper'

RSpec.describe Load::SalesBuilder, focus: true do
  subject(:built_sale) { Load::SalesBuilder.call(**sale_builder_arguments) }

  let(:sale_builder_arguments) do
    {
      price: 5,
      item_name: 'apples',
      department: 'produce department',
      store: 'totally real grocery store',
      package_measurement: 1
    }
  end

  before do
    produce_department  = Department.create!(name: 'produce department')
    apples              = Item.create!(name: 'apples', department: produce_department)
    fake_brand          = Brand.create!(name: 'totally real apple company')
    a_7kg_box_of_apples = Product.create!(item: apples, brand: fake_brand, measurement_units: 0)

    Package.create!(product: a_7kg_box_of_apples, unit_measurement: 7, unit_count: 3)
    Store.create!(name: 'totally real grocery store', location: 'a neighbourhood')
  end

  it { is_expected.to be_an_instance_of(Sale) }
  it { is_expected.to have_attributes(price: 5) }

  context 'when multiple sales have the same date, package and store' do
    subject { Sale.all }

    let(:duplicate_sale) { Sale.find_by(price: 1000) }

    before do
      Load::SalesBuilder.call(**sale_builder_arguments)
      Load::SalesBuilder.call(**sale_builder_arguments.merge({ price: 1000 }) )
    end

    it { is_expected.to contain_exactly(duplicate_sale) }
  end
end