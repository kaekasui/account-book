require 'rails_helper'

feature 'ユーザーアカウントの管理' do
  scenario 'ログインする' do
    user = create(:user, confirmed_at: Time.now)
    login user

    expect(current_path).to eq root_path
    expect(page).to have_content I18n.t("devise.sessions.signed_in")
  end

  scenario 'ログインに失敗する' do
    user = create(:user, email: "abc@example.com", confirmed_at: Time.now)

    visit root_path
    click_link I18n.t("links.sign_in")
    fill_in User.human_attribute_name(:email), with: "aaa@example.com"
    fill_in User.human_attribute_name(:password), with: user.password
    click_button I18n.t("buttons.sign_in")

    expect(current_path).to eq new_user_session_path
    expect(page).to have_content I18n.t("devise.failure.invalid")
  end

  scenario 'ログアウトする' do
    user = create(:user, confirmed_at: Time.now)
    login user
    
    click_link I18n.t("links.sign_out")

    expect(current_path).to eq root_path
    expect(page).to have_content I18n.t("devise.sessions.signed_out")
  end

  scenario '新規会員登録をする' do
    visit root_path

    click_link I18n.t("links.sign_up")
    fill_in User.human_attribute_name(:email), with: "new_user@example.com"
    fill_in User.human_attribute_name(:password), with: "password"
    fill_in User.human_attribute_name(:password_confirmation), with: "password"
    click_button I18n.t("buttons.sign_up")

    expect(current_path).to eq root_path
    expect(page).to have_content I18n.t("devise.registrations.signed_up_but_unconfirmed")

    user = User.find_by_email("new_user@example.com")
    open_email("new_user@example.com")
    mail_body = current_email.body
    index = mail_body.index("confirmation_token=")
    token = mail_body.slice(index+19..index+38)
    visit user_confirmation_path(confirmation_token: token)

    expect(current_path).to eq new_user_session_path

    fill_in User.human_attribute_name(:email), with: "new_user@example.com"
    fill_in User.human_attribute_name(:password), with: "password"
    click_button I18n.t("buttons.sign_in")

    expect(page).to have_content I18n.t("devise.sessions.signed_in")
  end

  scenario '新規会員登録に失敗する' do
    visit root_path
    click_link I18n.t("links.sign_up")
    fill_in User.human_attribute_name(:email), with: "new_user@example.com"
    fill_in User.human_attribute_name(:password), with: "password"
    fill_in User.human_attribute_name(:password_confirmation), with: ""
    click_button I18n.t("buttons.sign_up")

    expect(current_path).to eq user_registration_path
  end

  scenario 'ユーザー情報を更新する' do
    pending
    user = create(:user, confirmed_at: Time.now)
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
