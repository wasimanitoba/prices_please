# == Schema Information
#
# Table name: shopping_lists
#
#  id                  :bigint           not null, primary key
#  best_value_total    :decimal(, )
#  cheapest_total      :decimal(, )
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  best_value_store_id :bigint           not null
#  cheapest_store_id   :bigint
#
# Indexes
#
#  index_shopping_lists_on_best_value_store_id  (best_value_store_id)
#  index_shopping_lists_on_cheapest_store_id    (cheapest_store_id)
#
# Foreign Keys
#
#  fk_rails_...  (best_value_store_id => stores.id)
#  fk_rails_...  (cheapest_store_id => stores.id)
#
require 'rails_helper'

RSpec.describe ShoppingList, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
