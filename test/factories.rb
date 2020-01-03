# frozen_string_literal: true

# This will guess the User class
FactoryBot.define do
  factory :user do
    sequence :email do |n|
      "test#{n}@friend.gov"
    end
    password { 'friends4ever' }
    confirmed_at { DateTime.now }

    factory :user1 do
      email { 'test@user.gov' }
      password { 'aaaaaaa' }
    end
    factory :user2 do
      email { 'friend@user.gov' }
      password { 'bbbbbb' }
    end
  end
end

FactoryBot.define do
  factory :game do
    name { 'test ' }
    user { build(:user1) }
  end
end
