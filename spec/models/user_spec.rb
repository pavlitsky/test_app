require "rails_helper"

RSpec.describe User, type: :model do
  describe "associations" do
    it "has one account" do
      expect(subject)
        .to have_one(:account)
    end

    it "has many orders" do
      expect(subject)
        .to have_many(:orders)
    end
  end

  describe "validations" do
    it "requires email" do
      user = build(:user, email: nil)

      expect(user)
        .not_to be_valid

      expect(user.errors[:email])
        .to include("can't be blank")
    end
  end
end
