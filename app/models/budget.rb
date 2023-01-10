# frozen_string_literal: true

# == Schema Information
#
# Table name: budgets
#
#  id         :bigint           not null, primary key
#  duration   :string
#  public     :boolean          default(FALSE)
#  total      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Budget < ApplicationRecord
  attribute :duration, :duration

  has_many :budgets_users
  has_many :users, through: :budgets_users

  has_many :budgets_errands
  has_many :errands, through: :budgets_errands
end
