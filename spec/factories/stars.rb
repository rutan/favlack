FactoryGirl.define do
  factory :star do
    trait :with_user do
      user { FactoryGirl.build(:user) }
    end

    trait :with_message do
      message { FactoryGirl.build(:message) }
    end
  end
end
