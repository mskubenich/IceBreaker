FactoryGirl.define do
  factory :user do
    first_name 'Test'
    last_name 'Name'
    sequence(:user_name) { |n| "TestName#{n}" }
    sequence(:email) { |n| "test#{n}@mail.com" }
    password 'suppersecretpassword'
    gender 'male'
  end
end
