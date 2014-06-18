require 'rails_helper'

feature 'Record' do
  let(:user) { create(:user) }
  let(:category) { create(:category) }

  background do
    login user
  end

  scenario 'レコードを登録する' do
    breakdown = create(:breakdown, category_id: category.id, user_id: user.id)

    visit new_record_path
    select category.name, from: "category_name"
    fill_in 'record_charge', with: "900"
    click_button I18n.t("helpers.submit.create")

    expect(Record.last.charge).to eq 900
  end

  scenario '指定の年の履歴を表示する' do
    breakdown = create(:breakdown, category_id: category.id, user_id: user.id)

    # 2012年8月1日
    create(:record, breakdown_id: breakdown.id, user_id: user.id, published_at: "2012-08-01")
    visit records_path(year: 2012)
    expect(page).not_to have_content breakdown.name

    # 2012年1月1日
    create(:record, breakdown_id: breakdown.id, user_id: user.id, published_at: "2012-01-01")
    visit records_path(year: 2012)
    expect(page).to have_content breakdown.name
  end

  scenario '指定の月の履歴を表示する' do
    year = Date.today.year
    breakdown = create(:breakdown, category_id: category.id, user_id: user.id)
    
    create(:record, breakdown_id: breakdown.id, user_id: user.id, published_at: "#{year}-08-01")
    visit records_path(year: year, month: "08")
    expect(page).to have_content breakdown.name

    visit records_path(year: year, month: "06")
    expect(page).not_to have_content breakdown.name
  end
end