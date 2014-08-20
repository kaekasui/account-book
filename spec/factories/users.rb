FactoryGirl.define do
  factory :user, class: User do
    email "user@example.com"
    password "password"
  end 

  factory :edit_user, class: User do
    email "user@example.com"
    password "new_password"
    password_confirmation "new_password"
    current_password "password"
  end
end
