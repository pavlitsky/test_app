module Accounts
  class Debit
    def self.call(...)
      new(...).call
    end

    def initialize(account:, amount:, order:)
      @account = account
      @amount = amount
      @order = order
    end

    def call
      AccountTransaction.create!(
        account: @account,
        order: @order,
        amount_cents: -@amount.cents,
        transaction_type: :debit
      )

      @account.decrement!(:balance_cents, @amount.cents)

      @account
    end
  end
end
