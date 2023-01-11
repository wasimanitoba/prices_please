# frozen_string_literal: true

# == Schema Information
#
# Table name: departments
#
#  id         :bigint           not null, primary key
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Department < ApplicationRecord
  before_save do
    self.name = name.downcase
  end

  validates :name, presence: true
end
