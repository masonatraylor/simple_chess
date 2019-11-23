# This will guess the User class
FactoryBot.define do
  factory :user do
    email { 'test@user.gov' }
    password { 'aaaaaaa' }
  end
end

FactoryBot.define do
  factory :game do
    name { 'test '}
    user { build(:user) }
  end
end
