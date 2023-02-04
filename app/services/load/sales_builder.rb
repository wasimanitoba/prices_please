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

    # We're about to overwrite the Pipeline with a dummy variable to if it is nil make the code cleaner So we assign the
    # sales args early with the possibly nil pipeline because we want the sales_args to contain the input arg instead of the dummy variable
    @sales_args = { pipeline: pipeline, details: details, price: price }

    if pipeline.blank?
      raise StandardError, 'Missing both store and pipeline' if store.blank?

      raise StandardError, 'Missing both department and pipeline' if department.blank?

      # an empty object since we just need the store and department
      pipeline = Pipeline.new

      # assign department and store to the pipeline; overwrite any the strings with a model.
      pipeline.department = department.is_a?(String) ? Department.find_by(name: department) : department
      pipeline.store      = store.is_a?(String) ? Store.find_by(name: store) : store
    end

    item                  = Item.find_or_create_by(name: item_name, department: pipeline.department )
    @sales_args[:store]   = pipeline.store

    product               = Product.find_or_create_by(measurement_units: measurement_units, item_id: item.id, brand: brand)
    @sales_args[:package] = Package.find_or_create_by(unit_count: package_count, unit_measurement: package_measurement, product: product)
  end

  def call
    # Only retain one price per package size for a given date and a given store. Overwrite previous value.
    existing_sale = Sale.where(date: Date.current, **@sales_args.except(:price, :details)).first

    Rails.logger.info "Sales creation Service is now creating a Sale record with characteristics: #{@sales_args}"

    Sale.transaction do
      if existing_sale.present?
        existing_sale.destroy

        Rails.logger.warn "Deleted existing package sale at this store on this date: #{existing_sale.inspect}\n"
      end

      Load::SalesBuilder.insert_into_database(**@sales_args)
    end
  end

  def self.insert_into_database(package:, price:, store:, sale_qty: 1, pipeline: nil, details: nil)
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