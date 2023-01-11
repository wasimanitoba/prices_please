# frozen_string_literal: true

# == Schema Information
#
# Table name: budgets_errands
#
#  budget_id :bigint           not null
#  errand_id :bigint           not null
#
# Indexes
#
#  index_budgets_errands_on_budget_id_and_errand_id  (budget_id,errand_id)
#  index_budgets_errands_on_errand_id_and_budget_id  (errand_id,budget_id)
#
class BudgetsErrand < ApplicationRecord
  belongs_to :budget
  belongs_to :errand
end
