require "rails_helper"

RSpec.describe Account, type: :model do
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

  describe "validations" do
    it "requires user" do
      account = build(:account, user: nil)

      expect(account)
        .not_to be_valid
    end
  end
end
