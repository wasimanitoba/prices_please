# frozen_string_literal: true

# == Schema Information
#
# Table name: budgets_users
#
#  budget_id :bigint           not null
#  user_id   :bigint           not null
#
# Indexes
#
#  index_budgets_users_on_budget_id_and_user_id  (budget_id,user_id)
#  index_budgets_users_on_user_id_and_budget_id  (user_id,budget_id)
#
class BudgetsUser < ApplicationRecord
  belongs_to :user
  belongs_to :budget
end
