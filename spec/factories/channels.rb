FactoryGirl.define do
  factory :channel do
    uid { "C#{Faker::Lorem.characters(6)}" }
    name { Faker::Internet.user_name }
  end
end
