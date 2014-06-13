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
end
