# == Schema Information
#
# Table name: stores
#
#  id          :bigint           not null, primary key
#  coordinates :point
#  location    :string
#  name        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class Store < ApplicationRecord
  validates %i[name location], presence: true

  validates :name, uniqueness: { scope: :location }
end
