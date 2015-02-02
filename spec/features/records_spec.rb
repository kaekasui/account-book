require 'rails_helper'

feature 'Record' do
  let(:user) { create(:user, confirmed_at: Time.now) }
  let(:category) { create(:category, name: "category_name", user_id: user.id) }

  background do
    login user
  end

  scenario 'レコードを登録する' do
    create(:category, name: "category_name", user_id: user.id)
    visit root_path
    click_link I18n.t("menu.new_record")

    select category.name, from: "record_category_id"
    fill_in 'record_charge', with: "900"
    click_button I18n.t("helpers.submit.create")

    expect(Record.last.charge).to eq 900
  end

  scenario 'ラベルを指定してレコードを登録する' do
    create(:category, name: "category_name", user_id: user.id)
    visit root_path
    click_link I18n.t("menu.new_record")

    select category.name, from: "record_category_id"
    fill_in 'record_charge', with: "900"
    fill_in 'record_tagged', with: "タグ1"
    click_button I18n.t("helpers.submit.create")

    expect(Record.last.charge).to eq 900
    expect(Tag.first.name).to eq "タグ1"
  end

  scenario 'レコードの登録に失敗する' do
    create(:category, name: "category_name", user_id: user.id)
    visit root_path
    click_link I18n.t("menu.new_record")

    select category.name, from: "record_category_id"
    click_button I18n.t("helpers.submit.create")

    expect(page).to have_content I18n.t("errors.messages.blank")
  end

  scenario '指定の年の履歴を表示する' do
    create(:record, category_id: category.id, user_id: user.id, published_at: "2014-08-01")
    create(:record, category_id: category.id, user_id: user.id, published_at: "2012-08-01")

    visit records_path(year: 2014, month: 8)
    expect(page).to have_content category.name
    click_link "2012年"
    expect(page).to have_content category.name
  end

  scenario '指定の月の履歴を表示する' do
    year = Date.today.year
    create(:record, category_id: category.id, user_id: user.id, published_at: "#{year}-08-01")
    visit records_path(year: year, month: "08")
    expect(page).to have_content category.name

    visit records_path(year: year, month: "06")
    expect(page).not_to have_content category.name
  end

  scenario 'レコード作成後のメッセージからコピーして作成する' do
    create(:category, name: 'category_name', user_id: user.id)
    visit root_path
    click_link I18n.t('menu.new_record')

    select category.name, from: 'record_category_id'
    fill_in 'record_charge', with: '900'
    click_button I18n.t("helpers.submit.create")

    expect(Record.last.charge).to eq 900
    expect(page).to have_content I18n.t('labels.copy')
    click_link I18n.t('labels.copy')

    click_button I18n.t("helpers.submit.create")

    expect(Record.last.charge).to eq 900
    expect(Record.count).to eq 2
  end

  scenario 'レコード作成後のメッセージから編集する' do
    create(:category, name: 'category_name', user_id: user.id)
    visit root_path
    click_link I18n.t('menu.new_record')

    select category.name, from: 'record_category_id'
    fill_in 'record_charge', with: '900'
    click_button I18n.t("helpers.submit.create")

    expect(Record.last.charge).to eq 900

    expect(page).to have_content I18n.t('labels.edit')
    click_link I18n.t('labels.edit')

    fill_in 'record_charge', with: '1200'
    click_button I18n.t("helpers.submit.update")

    expect(Record.last.charge).to eq 1200
    expect(Record.count).to eq 1
  end
end
