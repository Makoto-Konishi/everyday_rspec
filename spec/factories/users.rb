FactoryBot.define do
  factory :user do
    first_name { 'hoge' }
    last_name { 'fuga' }
    sequence(:email) { |n| "test#{n}@example.com" }
    password { 'password' }
  end
end
