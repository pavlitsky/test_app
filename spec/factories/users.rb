FactoryBot.define do
  factory :user do
    email { "user-#{SecureRandom.uuid}@example.com" }

    after(:create) do |user|
      create(:account, user: user)
    end
  end
end
