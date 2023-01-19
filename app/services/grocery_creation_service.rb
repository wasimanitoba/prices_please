class GroceryCreationService < ApplicationService
  def initialize(details, store:, department:, user:)
    @details = details
    @department = department

    @sales_args = {
      user: user,
      store: store,
    }
  end

  def call()
    price = @details.second.gsub('ea', '').gsub('$', '')

    return if price.blank?

    name, measurement = @details.first.split(/\d/)

    if measurement.blank? || measurement == 0
      measurement = -1

      @sales_args[:details] = @details
    end

    item = Item.create!(name: name, department: @department)
    brand = Brand.find_or_create_by(name: 'Generic')
    product = Product.create!(measurement_units: 0, item_id: item.id, brand: brand)
    @sales_args[:package] = Package.create(unit_count: 1, unit_measurement: measurement, product: product)

    Sale.create!(price: price.to_d, date: Date.current, **@sales_args)
  end
end