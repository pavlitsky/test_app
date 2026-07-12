FactoryBot.define do
  factory :order do
    user
    amount_cents { 10_00 }
    status { :created }

    trait :completed do
      status { :completed }
    end

    trait :cancelled do
      status { :cancelled }
    end
  end
end
