# This will guess the User class
FactoryBot.define do
  factory :user do
    email { "test@user.gov" }
    password  { "aaaaaaa" }
  end
  factory :game do
  end
end