require 'rails_helper'

RSpec.describe Tag, type: :model do
  let(:user) { create(:user) }

  it 'ユーザー、カラーコード、ラベル名があれば有効であること' do
    tag = build(:tag, user_id: user.id)
    expect(tag).to be_valid
  end

  it 'カラーコードが空であればエラーが発生すること' do
    tag = build(:tag, color_code: '', user_id: user.id)
    expect(tag).to have(2).errors_on(:color_code)
  end

  it 'カラーコードが7文字以上であればエラーが発生すること' do
    tag = build(:tag, color_code: '#1234567', user_id: user.id)
    expect(tag).to have(1).errors_on(:color_code)
  end

  it 'カラーコードが5文字以下であればエラーが発生すること' do
    tag = build(:tag, color_code: '#12345', user_id: user.id)
    expect(tag).to have(1).errors_on(:color_code)
  end

  it '同じカラーコードを登録しようとした場合エラーが発生すること' do
    create(:tag, color_code: '#123456', user_id: user.id)
    tag = build(:tag, color_code: '#123456', user_id: user.id)
    expect(tag).to have(1).errors_on(:color_code)
  end

  it 'ラベル名が空であればエラーが発生すること' do
    tag = build(:tag, name: '', user_id: user.id)
    expect(tag).to have(1).errors_on(:name)
  end
end
