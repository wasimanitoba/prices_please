# frozen_string_literal: true

json.extract! errand, :id, :quantity, :maximum_spend, :brand_id, :estimated_serving_count,
              :estimated_serving_measurement, :user_id, :created_at, :updated_at
json.url errand_url(errand, format: :json)
