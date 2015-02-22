FactoryGirl.define do
  factory :message do
    ts { Time.now.to_f }
    body { Faker::Lorem.paragraph }
    permalink { Faker::Internet.url }

    trait :with_user do
      user { FactoryGirl.build(:user) }
    end

    trait :with_channel do
      channel { FactoryGirl.build(:channel) }
    end
  end
end
