require "rails_helper"

RSpec.describe Accounts::Debit do
  let(:user) { create(:user) }
  let(:account) { user.account }
  let(:order) { create(:order, user: user, amount_cents: 10_00) }

  before do
    account.update!(balance_cents: 50_00)
  end

  it "creates debit transaction" do
    expect {
      described_class.call(
        account: account,
        amount: order.amount,
        order: order
      )
    }.to change(AccountTransaction, :count).by(1)

    expect(AccountTransaction.last)
      .to be_debit
  end

  it "decreases account balance" do
    described_class.call(
      account: account,
      amount: order.amount,
      order: order
    )

    expect(account.reload.balance)
      .to eq(Money.from_amount(40))
  end
end
