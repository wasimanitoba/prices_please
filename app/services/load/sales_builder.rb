class Load::SalesBuilder < ApplicationService
  # Find or Build the package necessary to create a Sale
  # ... which requires first finding or building the associated Product which was sold,
  # ... and so on for the item type associated with the product.
  # NOTE: The pipeline can be blank but it can be used to find the required store and the required department for the item.
  #       Either the department and store must be explicitly provided by the caller, or a pipeline must be provided to infer them.
  def initialize(
      item_name:, price:, package_measurement:, measurement_units: 0, package_count: 1,
      store: nil, department: nil, brand: nil, pipeline: nil, details: nil
    )

    if pipeline.blank?
      raise ActiveRecordError::RecordInvalid, 'Missing both store and pipeline' if store.blank?

      raise ActiveRecordError::RecordInvalid, 'Missing both department and pipeline' if department.blank?
    end

    @sales_args = { pipeline: pipeline, store: (store || pipeline.store), details: details, price: price }

    item                  = Item.find_or_create_by(name: item_name, department: (department || pipeline.department) )
    product               = Product.find_or_create_by(measurement_units: measurement_units, item_id: item.id, brand: brand)
    @sales_args[:package] = Package.find_or_create_by(unit_count: package_count, unit_measurement: package_measurement, product: product)
  end

  def call
    # Only retain one price per package size for a given date
    existing_sale = Sale.where(date: Date.current, pipeline: @sales_args[:pipeline], package: @sales_args[:package]).first
    existing_sale.destroy if existing_sale.present?

    Rails.logger.info "Sales creation Service now creating Sale with characteristics: #{@sales_args} "

    Load::SalesBuilder.create_from_package(**@sales_args)
  rescue StandardError => e
    debugger
  end

  # Make it a bit easier to create Sales objects with some defaults
  def self.create_from_package(package:, price:, store:, sale_qty: 1, pipeline: nil, details: nil)
    Sale.create!(
      price: price.to_d,
      date: Date.current,
      package: package,
      quantity: sale_qty,
      store: store,
      details: details,
      pipeline: pipeline,
    )
  end
end