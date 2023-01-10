# frozen_string_literal: true

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
  validates :name, :location, presence: true

  validates :name, uniqueness: { scope: :location }
end
