require 'rails_helper'

feature 'Category' do
  background do
    user = create(:user)
    login user
  end

  scenario 'displays on the table'
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
end
