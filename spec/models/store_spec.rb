# frozen_string_literal: true

# == Schema Information
#
# Table name: stores
#
#  id          :bigint           not null, primary key
#  coordinates :point
#  location    :string           not null
#  name        :string           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
require 'rails_helper'

RSpec.describe Store, type: :model do
  describe '#best_deal_for_item' do; end
end
