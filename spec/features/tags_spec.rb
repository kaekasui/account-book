require 'rails_helper'

feature 'Tag' do
  let(:user) { create(:user, confirmed_at: Time.now) }
  let(:category) { create(:category, user_id: user.id) }
  let(:record) { create(:record, category_id: category.id, user_id: user.id, published_at: Time.now) }

  background do
    login user
  end

  scenario '履歴一覧にラベルが表示されること' do
    visit edit_record_path(id: record.id)
    fill_in 'record_tagged', with: 'ラベル'
    click_button I18n.t('buttons.update')

    visit records_path
    expect(page).to have_selector('.glyphicon.glyphicon-bookmark[title=ラベル]')
  end
end
