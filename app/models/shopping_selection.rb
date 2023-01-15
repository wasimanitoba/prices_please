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
# Foreign Keys
#
#  fk_rails_...  (best_matching_deal_id => sales.id)
#  fk_rails_...  (better_alternate_deal_id => sales.id)
#  fk_rails_...  (shopping_list_id => shopping_lists.id)
#
class ShoppingSelection < ApplicationRecord
  belongs_to :shopping_list, touch: true
  belongs_to :better_alternate_deal, class_name: 'Sale', foreign_key: 'better_alternate_deal', optional: true
  belongs_to :best_matching_deal, class_name: 'Sale', foreign_key: 'best_matching_deal_id'
end
