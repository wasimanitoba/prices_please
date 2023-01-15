# frozen_string_literal: true

# == Schema Information
#
# Table name: brands
#
#  id         :bigint           not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Brand < ApplicationRecord
  before_save do
    self.name = name.downcase
  end

  def inspect
    "#{name.titleize} - [Brand object ID: #{id}|#{object_id}]"
  end
end
