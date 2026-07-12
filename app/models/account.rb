class Account < ApplicationRecord
  belongs_to :user

  has_many :account_transactions, dependent: :restrict_with_exception

  monetize :balance_cents

  validates :balance_cents, numericality: { greater_than_or_equal_to: 0 }
end
