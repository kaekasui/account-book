require 'rails_helper'

RSpec.describe Breakdown, type: :model do
  let(:user) { create(:user) }
  let(:category) { create(:category) }

  it '内訳が空であればエラーが発生すること' do
    breakdown = build(:breakdown, name: "", user_id: user.id, category_id: category.id)
    expect(breakdown).to have(1).errors_on(:name)
  end

  it '内訳、ユーザー、カテゴリがあれば有効であること' do
    breakdown = build(:breakdown, name: "内訳", user_id: user.id, category_id: category.id) 
    expect(breakdown).to be_valid
  end

  it 'カテゴリがなければエラーが発生すること' do
    breakdown = build(:breakdown, name: "内訳", user_id: user.id)
    expect(breakdown).to have(1).errors_on(:category_id)
  end

  it 'ユーザーがなければエラーが発生すること' do
    breakdown = build(:breakdown, name: "内訳", category_id: category.id)
    expect(breakdown).to have(1).errors_on(:user_id)
  end

  it '論理削除となり削除時刻が更新されること' do
    breakdown = create(:breakdown, category_id: category.id, user_id: user.id)
    expect(breakdown.deleted_at).to be_nil
    breakdown.destroy
    expect(breakdown.deleted_at).not_to be_nil
  end

  it '入力上限値(40)を超える41文字の内訳であればエラーが発生すること' do
    breakdown = build(:breakdown, name: "あ" * 41, user_id: user.id, category_id: category.id) 
    expect(breakdown).to have(1).errors_on(:name)
  end

  it '入力上限値(40)を超えない40文字の内訳であれば有効であること' do
    breakdown = build(:breakdown, name: "あ" * 40, user_id: user.id, category_id: category.id) 
    expect(breakdown).to be_valid
  end
end
