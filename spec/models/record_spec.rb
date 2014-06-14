require 'rails_helper'

RSpec.describe Record, type: :model do
  let(:user) { create(:user) }
  let(:category) { create(:category) }
  let(:breakdown) { create(:breakdown, category_id: category.id, user_id: user.id) }

  it 'is valid with a charge, a user and a breakdown' do
    record = build(:record, breakdown_id: breakdown.id, user_id: user.id)
    expect(record).to be_valid
  end

  it 'is invalid without a charge' do
    record = build(:record, charge: "", breakdown_id: breakdown.id)
    expect(record).to be_invalid
  end

  it 'is invalid without a breakdown' do
    record = build(:record)
    expect(record).to be_invalid
  end

  it 'is invalid without a published date' do
    record = build(:record, published_at: '')
    expect(record).to be_invalid
  end

  it 'is invalid without a user' do
    record = build(:record, user_id: '')
    expect(record).to be_invalid
  end

  # 論理削除となり、削除時刻が更新されること
  it 'updates the deleted_at' do
    record = create(:record, breakdown_id: breakdown.id, user_id: user.id)
    expect(record.deleted_at).to be_nil
    record.destroy
    expect(record.deleted_at).not_to be_nil
  end
end
