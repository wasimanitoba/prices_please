# frozen_string_literal: true

# == Schema Information
#
# Table name: stores
#
#  id          :bigint           not null, primary key
#  coordinates :point
#  location    :string           not null
#  name        :string           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class Store < ApplicationRecord
  has_many :shopping_lists, inverse_of: :alternate_store
  has_many :shopping_lists, inverse_of: :recommend_store

  def to_s
    "#{location.titleize} #{name.titleize}"
  end

  def inspect
    "Store ##{id}: #{name.titleize} in #{location.titleize}"
  end

  validates :name, :location, presence: true

  validates :name, uniqueness: { scope: :location }
end
