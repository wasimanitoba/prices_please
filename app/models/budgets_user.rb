# frozen_string_literal: true

class BudgetsUser < ApplicationRecord
  belongs_to :user
  belongs_to :budget
end
