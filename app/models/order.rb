class Order < ApplicationRecord
  belongs_to :user

  has_many :account_transactions, dependent: :restrict_with_exception

  enum :status, {
    created: "created",
    completed: "completed",
    cancelled: "cancelled"
  }, default: :created

  monetize :amount_cents

  validates :amount_cents, numericality: { greater_than: 0 }
end
