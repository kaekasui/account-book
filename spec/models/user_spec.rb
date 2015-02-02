require 'rails_helper'

describe User, type: :model do
  it 'メールアドレスとパスワードがあれば有効であること' do
    user = build(:user)
    expect(user).to be_valid
  end

  it 'メールアドレスが空であればエラーが発生すること' do
    user = build(:user, email: "")
    expect(user).to have(1).errors_on(:email)
  end

  it 'パスワードが空であればエラーが発生すること' do
    user = build(:user, password: "")
    expect(user).to have(1).errors_on(:password)
  end

  it '論理削除となり削除時刻が更新されること' do
    user = create(:user, confirmed_at: Time.now)
    expect(user.deleted_at).to be_nil
    user.destroy
    expect(user.deleted_at).not_to be_nil
  end

  it '重複したメールアドレスであればエラーが発生すること' do
    create(:user, confirmed_at: Time.now)
    user = build(:user)
    expect(user).to have(1).errors_on(:email)
  end

  it '入力上限値(100)を超える101文字のメールアドレスであればエラーが発生すること' do
    user = build(:user, email: ("a" * 89) + "@example.com")
    expect(user).to have(1).errors_on(:email)
  end

  it '入力上限値(100)を超えない100文字のメールアドレスであれば有効であること' do
    user = build(:user, email: ("a" * 88) + "@example.com")
    expect(user).to be_valid
  end

  it '入力上限値(128)を超える129文字のパスワードであればエラーが発生すること' do
    user = build(:user, password: "a" * 129)
    expect(user).to have(1).errors_on(:password)
  end

  it '入力上限値(128)を超えない128文字のパスワードであれば有効であること' do
    user = build(:user, password: "a" * 128)
    expect(user).to be_valid
  end

  it '入力下限値(8)を超える8文字のパスワードであれば有効であること' do
    user = build(:user, password: "a" * 8)
    expect(user).to be_valid
  end

  it '入力下限値(8)を下回る7文字のパスワードであればエラーが発生すること' do
    user = build(:user, password: "a" * 7)
    expect(user).to have(1).errors_on(:password)
  end
end
