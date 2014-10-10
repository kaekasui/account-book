require 'rails_helper'

RSpec.describe Category, type: :model do
  let(:user) { create(:user) }

  it 'カテゴリ名が空であればエラーが発生すること' do
    category = build(:category, name: "", user_id: user.id)
    expect(category).to have(1).errors_on(:name)
  end

  it 'カテゴリ名があれば有効であること' do
    category = build(:category, user_id: user.id)
    expect(category).to be_valid
  end

  it '入力上限値(40)を超える41文字のカテゴリ名であればエラーが発生すること' do
    category = build(:category, name: "あ" * 41, user_id: user.id)
    expect(category).to have(1).errors_on(:name)
  end

  it '入力上限値(40)を超えない40文字のカテゴリ名であれば有効であること' do
    category = build(:category, name: "あ" * 40, user_id: user.id)
    expect(category).to be_valid
  end

  it '論理削除となり削除時刻が更新されること' do
    category = create(:category, user_id: user.id)
    expect(category.deleted_at).to be_nil
    category.destroy
    expect(category.deleted_at).not_to be_nil
  end

  describe '収支の名称について' do
    it 'デフォルトで「支出」が返ってくること' do
      category = create(:category, user_id: user.id)
      expect(category.barance_of_payments_name).to eq I18n.t("category.outgo")
    end

    it '0を指定することで「支出」が返ってくること' do
      category = create(:category, barance_of_payments: 0, user_id: user.id)
      expect(category.barance_of_payments_name).to eq I18n.t("category.outgo")
    end

    it '1を指定することで「収入」が返ってくること' do
      category = create(:category, barance_of_payments: 1, user_id: user.id)
      expect(category.barance_of_payments_name).to eq I18n.t("category.income")
    end
  end

  context 'カテゴリを削除した場合' do
    it 'カテゴリに紐づく内訳が論理削除されること' do
      category = create(:category, user_id: user.id)
      breakdown = create(:breakdown, category_id: category.id, user_id: user.id)
      expect(breakdown.reload.deleted_at).to be_nil
      category.destroy
      expect(breakdown.reload.deleted_at).not_to be_nil
    end

    it "カテゴリに紐づかない内訳が削除されないこと" do
      category = create(:category, user_id: user.id)
      category2 = create(:category, user_id: user.id)
      breakdown = create(:breakdown, category_id: category2.id, user_id: user.id)
      expect(breakdown.reload.deleted_at).to be_nil
      category.destroy
      expect(breakdown.reload.deleted_at).to be_nil
    end
  end
end
