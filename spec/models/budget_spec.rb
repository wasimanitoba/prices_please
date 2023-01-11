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
require 'rails_helper'

RSpec.describe Budget, type: :model do
  describe '#to_s' do
    subject { Budget.create!(users: users, duration: 1.week, total: 100_000).to_s }

    let(:users)  { [User.create!(email: 'fake', password: 'fake')] }
    let(:dept)   { Department.create!(name: 'fake') }

    it { is_expected.to eq("$100,000.00 budgeted for 1 week including 0 items") }
  end
end
