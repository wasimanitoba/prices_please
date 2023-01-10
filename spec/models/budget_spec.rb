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
require 'rails_helper'

RSpec.describe Budget, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
