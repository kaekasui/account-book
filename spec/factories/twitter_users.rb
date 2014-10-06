FactoryGirl.define do
  factory :twitter_user, class: TwitterUser do
    uid "user_id"
    name "name"
    nickname "nickname"
    token "token"
    provider "twitter"
  end 
end
