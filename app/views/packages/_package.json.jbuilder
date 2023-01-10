# frozen_string_literal: true

json.extract! package, :id, :unit_measurement, :product_id, :unit_count, :total_measurement, :created_at, :updated_at
json.url package_url(package, format: :json)
