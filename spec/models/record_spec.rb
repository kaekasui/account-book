require 'rails_helper'

RSpec.describe Record, type: :model do
  let(:user) { create(:user) }
  let(:category) { create(:category, user_id: user.id) }
  let(:breakdown) { create(:breakdown, category_id: category.id, user_id: user.id) }

  it '内訳、ユーザー、料金があれば有効であること' do
    record = build(:record, breakdown_id: breakdown.id, user_id: user.id)
    expect(record).to be_valid
  end

  it '料金が空であればエラーが発生すること' do
    record = build(:record, charge: "", breakdown_id: breakdown.id)
    expect(record).to have(1).errors_on(:charge)
  end

  it '内訳がなければエラーが発生すること' do
    record = build(:record)
    expect(record).to have(1).errors_on(:breakdown_id)
  end

  it '日付がなければエラーが発生すること' do
    record = build(:record, published_at: '')
    expect(record).to have(1).errors_on(:published_at)
  end

  it 'ユーザーがなければエラーが発生すること' do
    record = build(:record, user_id: '')
    expect(record).to have(1).errors_on(:user_id)
  end

  it '論理削除となり削除時刻が更新されること' do
    record = create(:record, breakdown_id: breakdown.id, user_id: user.id)
    expect(record.deleted_at).to be_nil
    record.destroy
    expect(record.deleted_at).not_to be_nil
  end
end
