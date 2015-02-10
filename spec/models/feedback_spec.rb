require 'rails_helper'

RSpec.describe Feedback, type: :model do
  let(:user) { create(:user) }

  it '内容が空であればエラーが発生すること' do
    feedback = build(:feedback, content: '', user_id: user.id)
    expect(feedback).to have(1).errors_on(:content)
  end
end
