# frozen_string_literal: true

class BudgetsErrand < ApplicationRecord
  belongs_to :budget
  belongs_to :errand
end
