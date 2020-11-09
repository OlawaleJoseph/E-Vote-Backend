require 'faker'

FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    first_name { Faker::Name.unique.name }
    last_name { Faker::Name.unique.name  }
    password { 'Password1' }
    username { Faker::Name.unique.name }
    email_notification { 'true' }
    plan { 0 }
  end
end
