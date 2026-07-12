class User < ApplicationRecord
  has_one :account
  has_many :orders

  validates :email, presence: true, uniqueness: true
end
