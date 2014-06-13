require 'rails_helper'

describe User type: :model do
  # メールアドレスとパスワードが有れば有効な状態であること
  it 'is valid with a email.' do
    user = build(:user)
    expect(user).to be_valid
  end

  # メールアドレスが無ければ無効な状態であること
  it 'is invalid without a email.' do
    user = build(:user, email: "")
    expect(user).to have(1).errors_on(:email)
  end

  # パスワードが無ければ無効な状態であること
  it 'is invalid without a password.' do
    user = build(:user, password: "")
    expect(user).to have(1).errors_on(:password)
  end

  # 論理削除となり、削除時刻が更新されること
  it 'updates the deleted_at' do
    user = create(:user)
    expect(user.deleted_at).to be_nil
    user.destroy
    expect(user.deleted_at).not_to be_nil
  end
end
