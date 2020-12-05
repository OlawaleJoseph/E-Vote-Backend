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

  factory :poll do
    title { 'Test' }
    info { 'A test poll' }
    restricted { false }
    start_date { DateTime.now }
    end_date { DateTime.now + 2 }
    img_url { 'imageurlhere' }
    host_id { 1 }
  end

  factory :poll_question do
    poll_id { 1 }
    content { 'The poll question' }
  end

  factory :poll_answer do
    poll_id { 1 }
    poll_question_id { 1 }
    content { 'Answer 1' }
  end
end
