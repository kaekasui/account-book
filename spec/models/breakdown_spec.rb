require 'rails_helper'

RSpec.describe Breakdown, type: :model do
  let(:user) { create(:user) }
  let(:category) { create(:category) }

  # 内訳が無ければ無効な状態であること
  it 'is invalid without a breakdown' do
    breakdown = build(:breakdown, name: "", user_id: user.id, category_id: category.id)
    expect(breakdown).to be_invalid
  end

  # 内訳、ユーザー、カテゴリが有れば有効な状態であること
  it 'is valid with a breakdown' do
    breakdown = build(:breakdown, name: "内訳", user_id: user.id, category_id: category.id) 
    expect(breakdown).to be_valid
  end

  # カテゴリが無ければ無効な状態であること
  it 'is invalid without a category' do
    breakdown = build(:breakdown, name: "内訳", user_id: user.id)
    expect(breakdown).to be_invalid
  end

  # ユーザーが無ければ無効な状態であること
  it 'is invalid without a user' do
    breakdown = build(:breakdown, name: "内訳", category_id: category.id)
    expect(breakdown).to be_invalid
  end

  # 論理削除となり、削除時刻が更新されること
  it 'updates the deleted_at' do
    breakdown = create(:breakdown, category_id: category.id, user_id: user.id)
    expect(breakdown.deleted_at).to be_nil
    breakdown.destroy
    expect(breakdown.deleted_at).not_to be_nil
  end
end
