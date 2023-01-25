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
  # TODO: add the start/end dates as explicit fields along with the pre-computed duration
  include ActionView::Helpers::NumberHelper
  include BudgetsHelper

  attribute :duration, :duration

  has_many :budgets_users
  has_many :users, through: :budgets_users

  has_many :budgets_errands
  has_many :errands, through: :budgets_errands
  accepts_nested_attributes_for :errands, reject_if: :all_blank, allow_destroy: true

  def to_s
    "#{number_to_currency(total)} budgeted for #{duration_as_time(duration)} including #{errands.size} items"
  end
end
