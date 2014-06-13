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
end
