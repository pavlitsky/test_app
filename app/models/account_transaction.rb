class AccountTransaction < ApplicationRecord
  belongs_to :account
  belongs_to :order

  enum :transaction_type, {
    debit: "debit",
    credit: "credit"
  }

  monetize :amount_cents

  validates :amount_cents, numericality: { other_than: 0 }
end
