require "rails_helper"

RSpec.describe Order, type: :model do
  describe "associations" do
    it "belongs to user" do
      expect(subject)
        .to belong_to(:user)
    end

    it "has many account transactions" do
      expect(subject)
        .to have_many(:account_transactions)
    end
  end

  describe "enums" do
    it "has order statuses" do
      expect(Order.statuses.keys)
        .to contain_exactly(
          "created",
          "completed",
          "cancelled"
        )
    end
  end

  describe "validations" do
    it "requires amount" do
      order = build(:order, amount_cents: nil)

      expect(order)
        .not_to be_valid
    end

    it "requires user" do
      order = build(:order, user: nil)

      expect(order)
        .not_to be_valid
    end
  end
end
