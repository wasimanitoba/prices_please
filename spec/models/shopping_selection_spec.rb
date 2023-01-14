# == Schema Information
#
# Table name: shopping_selections
#
#  id                       :bigint           not null, primary key
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  best_matching_deal_id    :bigint           not null
#  better_alternate_deal_id :bigint
#  shopping_list_id         :bigint           not null
#
# Indexes
#
#  index_shopping_selections_on_best_matching_deal_id     (best_matching_deal_id)
#  index_shopping_selections_on_better_alternate_deal_id  (better_alternate_deal_id)
#  index_shopping_selections_on_shopping_list_id          (shopping_list_id)
#
require 'rails_helper'

RSpec.describe ShoppingSelection, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
