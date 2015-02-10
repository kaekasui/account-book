require 'rails_helper'

feature 'カテゴリの管理' do
  background do
    @user = create(:user, confirmed_at: Time.now)
    login @user
  end

  scenario 'カテゴリの一覧を表示する'
  # js: true
  #     visit categories_path
  #     # カテゴリを登録する
  #     category_name = 'new_category'
  #     choose 'category_barance_of_payments_0', visible: false
  #     #fill_in 'category_name', with: category_name + '\n'
  #
  #     page.execute_script(<<-JS)
  #       $("input#category_name").attr("value", category_name);
  #       $("input#category_name").trigger({type: "keypress", keyCode: "13"});
  #     JS
  #     #expect(page).to have_content(category_name)

  scenario 'カテゴリの一覧に内訳を表示する' do
    category = create(:category, barance_of_payments: 0, user_id: @user.id)
    breakdown = create(:breakdown, user_id: @user.id, category_id: category.id)
    visit categories_path

    expect(page).to have_content(category.name)
    expect(page).to have_content(breakdown.name)
  end

  scenario 'カテゴリごとに記録を表示する' do
    category = create(:category, barance_of_payments: 0, user_id: @user.id)
    visit categories_path
    click_link category.name

    expect(page).to have_content(category.name)
  end
end
