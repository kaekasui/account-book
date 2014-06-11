require 'rails_helper'

describe User do
  # メールアドレスがあれば有効な状態であること
  it 'is valid with a email.' do
    user = build(:user)
    expect(user).to be_valid
  end

  # メールアドレスが無ければ無効な状態であること
  it 'is invalid without a email.' do
    user = build(:user, email: "")
    expect(user).to have(1).errors_on(:email)
  end
end
