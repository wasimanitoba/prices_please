# == Schema Information
#
# Table name: pipelines
#
#  id            :bigint           not null, primary key
#  target        :string           not null
#  website       :string           not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  department_id :bigint           not null
#  store_id      :bigint           not null
#
# Indexes
#
#  index_pipelines_on_department_id  (department_id)
#  index_pipelines_on_store_id       (store_id)
#
# Foreign Keys
#
#  fk_rails_...  (department_id => departments.id)
#  fk_rails_...  (store_id => stores.id)
#
class Pipeline < ApplicationRecord
  belongs_to :department
  belongs_to :store
end
