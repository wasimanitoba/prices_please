# frozen_string_literal: true

# == Schema Information
#
# Table name: budgets
#
#  id         :bigint           not null, primary key
#  duration   :string
#  public     :boolean          default(FALSE)
#  total      :decimal(, )
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Budget < ApplicationRecord
  include ActionView::Helpers::NumberHelper

  attribute :duration, :duration

  has_many :budgets_users
  has_many :users, through: :budgets_users

  has_many :budgets_errands
  has_many :errands, through: :budgets_errands

  # Alias the duration for printing as string because our underlying representation is a serialized string
  def duration_as_time
    duration.inspect
  end

  def to_s
    "#{number_to_currency(total)} budgeted for #{duration_as_time} including #{errands.size} items"
  end
end
