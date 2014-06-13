require 'rails_helper'

feature 'User' do
  # ログインする
  scenario 'logs in.' do
    user = create(:user)
    login user

    expect(current_path).to eq root_path
    expect(page).to have_content I18n.t("devise.sessions.signed_in")
  end

  # ログインに失敗する
  scenario 'doesn\'t log in.' do
    user = create(:user, email: "abc@example.com")

    visit root_path
    click_link I18n.t("links.sign_in")
    fill_in User.human_attribute_name(:email), with: "aaa@example.com"
    fill_in User.human_attribute_name(:password), with: user.password
    click_button I18n.t("buttons.sign_in")

    expect(current_path).to eq new_user_session_path
    expect(page).to have_content I18n.t("devise.failure.invalid")
  end

  # ログアウトする
  scenario 'logs out.' do
    user = create(:user)
    login user
    
    click_link I18n.t("links.sign_out")

    expect(current_path).to eq root_path
    expect(page).to have_content I18n.t("devise.sessions.signed_out")
  end

  # 会員登録する
  scenario 'creates a user.' do
    visit root_path

    click_link I18n.t("links.sign_up")
    fill_in User.human_attribute_name(:email), with: "new_user@example.com"
    fill_in User.human_attribute_name(:password), with: "password"
    fill_in User.human_attribute_name(:password_confirmation), with: "password"
    click_button I18n.t("helpers.submit.user.create")

    expect(current_path).to eq root_path
    expect(page).to have_content I18n.t("devise.registrations.signed_up")
  end

  # 会員登録に失敗する
  scenario 'doesn\'t create a user.' do
    visit root_path
    click_link I18n.t("links.sign_up")
    fill_in User.human_attribute_name(:email), with: "new_user@example.com"
    fill_in User.human_attribute_name(:password), with: "password"
    fill_in User.human_attribute_name(:password_confirmation), with: ""
    click_button I18n.t("helpers.submit.user.create")

    expect(current_path).to eq user_registration_path
  end

  # ユーザー情報を更新する
  scenario 'update a user.' do
    pending
    user = create(:user)
    login user

    visit edit_user_registration_path
    fill_in User.human_attribute_name(:email), with: user.email
    fill_in User.human_attribute_name(:password), with: "12345678"
    fill_in User.human_attribute_name(:password_confirmation), with: "12345678"
    fill_in User.human_attribute_name(:current_password), with: user.password
    click_button I18n.t("helpers.submit.user.update")

    expect(current_path).to eq root_path
  end
end
