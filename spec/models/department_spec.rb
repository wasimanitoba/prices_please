# frozen_string_literal: true

# == Schema Information
#
# Table name: departments
#
#  id         :bigint           not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require 'rails_helper'

RSpec.describe Department, type: :model do
  context 'when creating a department without a name' do
    subject(:department) { Department.new(name: '') }

    it { expect { department.save! }.to raise_error(ActiveRecord::RecordInvalid) }
  end
end
