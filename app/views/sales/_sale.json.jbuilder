# frozen_string_literal: true

json.extract! sale, :id, :price, :package_id, :store_id, :user_id, :date, :quantity, :created_at, :updated_at
json.url sale_url(sale, format: :json)
