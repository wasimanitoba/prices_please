json.extract! shopping_list, :id, :recommend_store_id, :alternate_store_id, :total_price, :created_at, :updated_at
json.url shopping_list_url(shopping_list, format: :json)
