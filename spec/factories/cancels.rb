# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :cancel do
    user_id 1
    content "MyText"
  end
end
