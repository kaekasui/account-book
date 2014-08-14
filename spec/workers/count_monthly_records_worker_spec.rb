require 'rails_helper'

describe CountMonthlyRecordsWorker do
  let(:user) { create(:user) }
  let(:category) { create(:category, user_id: user.id) }
  let(:breakdown) { create(:breakdown, category_id: category.id, user_id: user.id) }
  let(:record) { create(:record, breakdown_id: breakdown.id, user_id: user.id) }

  it 'ジョブがキューに入ること' do
    pending
    subject.perform record.id
    should be_processed_in(:sidekiq)
  end
end
