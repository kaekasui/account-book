require 'rails_helper'

describe TwitterUser, type: :model do
  it 'メールアドレスがなくでも有効であること' do
    twitter_user = build(:twitter_user)
    expect(twitter_user).to be_valid
  end
end
