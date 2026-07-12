require "rails_helper"

RSpec.describe Orders::Cancel do
  let(:user) { create(:user) }
  let(:account) { user.account }

  describe ".call" do
    context "when order is completed" do
      let(:order) { create(:order, :completed, user: user, amount_cents: 10_00) }

      before do
        account.update!(balance_cents: 0)
      end

      it "changes order status to cancelled" do
        described_class.call(order)

        expect(order.reload)
          .to be_cancelled
      end

      it "creates credit transaction" do
        expect {
          described_class.call(order)
        }.to change(AccountTransaction, :count).by(1)

        transaction = AccountTransaction.last

        expect(transaction)
          .to be_credit

        expect(transaction.amount)
          .to eq(Money.from_amount(10))
      end

      it "restores account balance" do
        described_class.call(order)

        expect(user.account.reload.balance)
          .to eq(Money.from_amount(10))
      end

      it "is idempotent" do
        described_class.call(order)

        expect {
          described_class.call(order)
        }.not_to change(AccountTransaction, :count)

        expect(user.account.reload.balance)
          .to eq(Money.from_amount(10))
      end
    end

    context "when order is not completed" do
      let(:order) { create(:order, :created, user: user, amount_cents: 10_00) }

      it "raises error" do
        expect {
          described_class.call(order)
        }.to raise_error(InvalidOrderStatusError, "Order is not completed")
      end

      it "does not create transaction" do
        expect {
          begin
            described_class.call(order)
          rescue InvalidOrderStatusError
            nil
          end
        }.not_to change(AccountTransaction, :count)
      end

      it "does not change account balance" do
        expect {
          begin
            described_class.call(order)
          rescue InvalidOrderStatusError
            nil
          end
        }.not_to change(user.account, :balance_cents)
      end
    end
  end
end
