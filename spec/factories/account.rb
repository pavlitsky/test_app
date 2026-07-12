FactoryBot.define do
  factory :account do
    user

    balance_cents { 0 }
  end
end
