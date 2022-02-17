FactoryBot.define do
  factory :user do
    first_name { 'hoge' }
    last_name { 'fuga' }
    email { 'test@example.com' }
    password { 'password' }
  end
end
