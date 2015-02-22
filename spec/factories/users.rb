FactoryGirl.define do
  factory :user do
    uid { "U#{Faker::Lorem.characters(6)}" }
    name { Faker::Internet.user_name }
    avatar_url { Faker::Internet.url }
  end
end
