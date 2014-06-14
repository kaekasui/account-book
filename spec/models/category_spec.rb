require 'rails_helper'

RSpec.describe Category, type: :model do

  # カテゴリ名が無ければ無効な状態であること
  it 'is invalid without a category name.' do
    category = build(:category, name: "")
    expect(category).to be_invalid
  end

  # カテゴリ名が有れば有効な情報であること
  it 'is valid with a category name.' do
    category = build(:category)
    expect(category).to be_valid
  end

  # カテゴリ名が101文字であれば無効な状態であること
  it 'is invalid with 101 characters category name' do
    category = build(:category, name: "あ" * 101)
    expect(category).to be_invalid
  end

  # カテゴリ名が100文字であれば有効な状態であること
  it 'is valid with 100 characters category name' do
    category = build(:category, name: "あ" * 100)
    expect(category).to be_valid
  end

  # 論理削除となり、削除時刻が更新されること
  it 'updates the deleted_at' do
    category = create(:category)
    expect(category.deleted_at).to be_nil
    category.destroy
    expect(category.deleted_at).not_to be_nil
  end

  describe '#barance_of_payments_name' do
    it 'returns a outgo of the category with default' do
      category = create(:category)
      expect(category.barance_of_payments_name).to eq I18n.t("category.outgo")
    end

    it 'returns a outgo of the category' do
      category = create(:category, barance_of_payments: 0)
      expect(category.barance_of_payments_name).to eq I18n.t("category.outgo")
    end

    it 'returns a income of the category' do
      category = create(:category, barance_of_payments: 1)
      expect(category.barance_of_payments_name).to eq I18n.t("category.income")
    end
  end
end
