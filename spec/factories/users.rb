FactoryGirl.define do
  factory :user, class: User do
    email "user@example.com"
    password "password"
  end 
end
