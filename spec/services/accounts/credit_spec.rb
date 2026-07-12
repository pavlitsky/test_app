require "rails_helper"

RSpec.describe Accounts::Credit do
  let(:user) { create(:user) }
  let(:account) { user.account }
  let(:order) { create(:order, user: user, amount_cents: 10_00) }

  it "creates credit transaction" do
    expect {
      described_class.call(
        account: account,
        amount: order.amount,
        order: order
      )
    }.to change(AccountTransaction, :count).by(1)

    expect(AccountTransaction.last)
      .to be_credit
  end

  it "increases account balance" do
    described_class.call(
      account: account,
      amount: order.amount,
      order: order
    )

    expect(account.reload.balance)
      .to eq(Money.from_amount(10))
  end
end
