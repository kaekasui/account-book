require 'rails_helper'

describe Answer, type: :model do
  let(:user) { create(:user) }
  let(:feedback) { create(:feedback, user_id: user.id) }

  it '回答があれば有効であること' do
    answer = build(:answer, user_id: user.id, feedback_id: feedback.id)
    expect(answer).to be_valid
  end

  it '回答が無ければエラーが発生すること' do
    answer = build(:answer, content: '', user_id: user.id, feedback_id: feedback.id)
    expect(answer).to have(1).errors_on(:content)
  end
end
