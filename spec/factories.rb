require 'faker'

FactoryBot.define do
  factory :program do
    configuration { { auto_resolve: false, auto_define: true } }
  end
  factory :user do
    email { Faker::Internet.email }
    first_name { Faker::Name.unique.name }
    last_name { Faker::Name.unique.name  }
    password { 'Password1' }
    username { Faker::Name.unique.name }
    email_notification { 'true' }
    plan { 0 }
  end

  factory :confirmed_user, parent: :user do
    after(:create) { |user| user.confirm! }
  end
end
