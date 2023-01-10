# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id              :bigint           not null, primary key
#  email           :string
#  password_digest :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
class User < ApplicationRecord
  has_many :budgets_users
  has_many :budgets, through: :budgets_users

  has_secure_password

  validates :email, presence: true, uniqueness: true
end
