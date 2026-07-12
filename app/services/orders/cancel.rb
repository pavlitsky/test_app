module Orders
  class Cancel
    def self.call(...)
      new(...).call
    end

    def initialize(order)
      @order = order
    end

    def call
      Order.transaction do
        @order.lock!

        return @order if @order.cancelled?
        raise InvalidOrderStatusError, "Order is not completed" unless @order.completed?

        account = @order.user.account
        account.lock!

        Accounts::Credit.call(account: account, amount: @order.amount, order: @order)

        @order.update!(status: :cancelled)
      end
      @order
    end
  end
end
