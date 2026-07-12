require "rails_helper"
RSpec.describe Orders::Complete do
  let(:user) { create(:user) }
  let(:account) { user.account }
  let(:order) { create(:order, user: user, amount_cents: 10_00) }

  before do
    account.update!(balance_cents: 50_00)
  end

  describe ".call" do
    it "marks order as completed and creates transaction" do
      described_class.call(order)

      expect(order.reload)
        .to be_completed

      expect(AccountTransaction.where(order: order))
        .to have_attributes(count: 1)

      expect(account.reload.balance)
        .to eq(Money.from_amount(40))
    end

    it "does not create duplicate transactions with concurrent calls" do
      threads = 2.times.map do
        Thread.new do
          described_class.call(order)
        end
      end

      threads.each(&:join)

      expect(AccountTransaction.where(order: order))
        .to have_attributes(count: 1)

      expect(account.reload.balance)
        .to eq(Money.from_amount(40))
    end

    it "is idempotent when order is already completed" do
      described_class.call(order)

      expect { described_class.call(order) }
        .not_to change(AccountTransaction, :count)

      expect(account.reload.balance)
        .to eq(Money.from_amount(40))
    end

    context "when debit operation fails" do
      before do
        allow(Accounts::Debit)
          .to receive(:call)
          .and_raise(StandardError, "debit failed")
      end

      it "keeps order unchanged" do
        expect {
          described_class.call(order)
        }.to raise_error(StandardError, "debit failed")

        expect(order.reload)
          .to be_created

        expect(account.reload.balance)
          .to eq(Money.from_amount(50))

        expect(AccountTransaction.where(order: order))
          .to be_empty
      end
    end
  end
end
