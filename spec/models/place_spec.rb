require 'rails_helper'

RSpec.describe Place, type: :model do
  it '名称が空であればエラーが発生すること' do
    category = build(:place, name: "")
    expect(category).to have(1).errors_on(:name)
  end
end
