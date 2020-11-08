FactoryBot.define do
  factory :user do
    email { 'abc@gmail.com' }
    first_name { 'John' }
    last_name { 'Doe' }
    password { 'Password1' }
    username { 'johndoe' }
    email_notification { 'true' }
    plan { 0 }
  end
end
