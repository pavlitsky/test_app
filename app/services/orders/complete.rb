module Orders
  class Complete
    def self.call(order)
      new(order).call
    end

    def initialize(order)
      @order = order
    end

    def call
      Order.transaction do
        @order.lock!
        return @order if @order.completed?

        account = @order.user.account
        account.lock!

        raise InsufficientFundsError if account.balance < @order.amount

        Accounts::Debit.call(account: account, amount: @order.amount, order: @order)

        @order.update!(status: :completed)
      end
      @order
    rescue ActiveRecord::RecordNotUnique
      @order.reload
    end
  end
end
