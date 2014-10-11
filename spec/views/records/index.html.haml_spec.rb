require 'rails_helper'

RSpec.describe "records/index", type: :view do
  let(:user) { create(:user, confirmed_at: Time.now) }
  let(:category) { create(:category, user_id: user.id) }
  let(:breakdown) { create(:breakdown, user_id: user.id, category_id: category.id) }

  before(:each) do
    assign(:records, [
      create(:record, user_id: user.id, category_id: category.id, published_at: Date.today),
      create(:record, user_id: user.id, category_id: category.id, published_at: Date.today)
    ])
  end

  it "一覧が表示されること" do
    render
    assert_select('tr > td', text: Date.today.to_s, count: 2)
  end
end
