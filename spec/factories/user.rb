FactoryGirl.define do
  factory :user do
    sequence(:user_name){ |n| "test#{n}" }
    first_name 'Test'
    last_name 'User'
    gender 'male'
    date_of_birth Time.now - 20.years
    sequence(:email){ |n| "test#{n}@example.com" }
    show_email true
    sended_messages_count 0
    received_messages_count 0
    password 'secret11'
    password_confirmation 'secret11'
  end
end