require "rails_helper"

RSpec.describe "Orders", type: :request do
  describe "POST /orders" do
    let!(:user) { create(:user) }
    let(:account) { user.account }

    before do
      account.update!(balance_cents: 50_00)

      allow_any_instance_of(ApplicationController)
        .to receive(:current_user)
        .and_return(user)
    end

    it "creates order" do
      expect {
        post orders_path,
             params: { order: { amount_cents: 10_00 } },
             as: :json
      }.to change(Order, :count).by(1)

      expect(response)
        .to have_http_status(:created)

      expect(Order.last)
        .to be_created
    end

    it "does not change balance" do
      post orders_path,
           params: { order: { amount_cents: 10_00 } },
           as: :json

      expect(user.account.reload.balance)
        .to eq(Money.from_amount(50))
    end
  end

  describe "POST /orders/:id/complete" do
    let(:user) { create(:user) }
    let(:account) { user.account }
    let(:order) { create(:order, user: user, amount_cents: 10_00) }

    before do
      account.update!(balance_cents: 50_00)
    end

    it "completes order" do
      post complete_order_path(order), as: :json

      expect(response)
        .to have_http_status(:ok)

      expect(order.reload)
        .to be_completed
    end

    it "does not create duplicate transactions with concurrent calls" do
      threads =
        2.times.map do
          Thread.new do
            Orders::Complete.call(order)
          end
        end

      threads.each(&:join)

      expect(order.reload).to be_completed

      expect(AccountTransaction.where(order: order, transaction_type: :debit).count)
        .to eq(1)

      expect(user.account.reload.balance)
        .to eq(Money.from_amount(40))
    end
  end

  describe "POST /orders/:id/cancel" do
    let(:user) { create(:user) }
    let(:order) { create(:order, :completed, user: user, amount_cents: 10_00) }

    it "cancels order" do
      post cancel_order_path(order)

      expect(order.reload)
        .to be_cancelled
    end
  end
end
