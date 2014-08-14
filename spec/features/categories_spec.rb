require 'rails_helper'

feature 'カテゴリの管理' do
  background do
    user = create(:user, confirmed_at: Time.now)
    login user
  end

  scenario 'カテゴリの一覧を表示する'
=begin
js: true
    visit categories_path
    # カテゴリを登録する
    category_name = 'new_category'
    choose 'category_barance_of_payments_0', visible: false
    #fill_in 'category_name', with: category_name + '\n'

    page.execute_script(<<-JS)
      $("input#category_name").attr("value", category_name);
      $("input#category_name").trigger({type: "keypress", keyCode: "13"});
    JS
    #expect(page).to have_content(category_name)
=end

  scenario "カテゴリごとに記録を表示する" do
    category = create(:category, barance_of_payments: 1)
    visit categories_path
    click_link category.name

    expect(page).to have_content(category.name)
  end
end
