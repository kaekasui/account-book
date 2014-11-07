require 'rails_helper'

feature 'Twitterアカウントの管理' do
  scenario 'ログインする' do
    visit "/users/auth/twitter"

    expect(current_path).to eq root_path
    expect(page).to have_content I18n.t("devise.omniauth_callbacks.success", kind: 'twitter')
  end

  scenario 'ログインする(2回目)' do
    visit "/users/auth/twitter"

    expect(current_path).to eq root_path
    expect(page).to have_content I18n.t("devise.omniauth_callbacks.success", kind: 'twitter')
    click_link I18n.t("links.sign_out")

    visit "/users/auth/twitter"
    expect(current_path).to eq root_path
    expect(page).to have_content I18n.t("devise.omniauth_callbacks.success", kind: 'twitter')
  end

  scenario 'ログアウトする' do
    visit "/users/auth/twitter"

    expect(current_path).to eq root_path
    expect(page).to have_content I18n.t("devise.omniauth_callbacks.success", kind: 'twitter')

    click_link I18n.t("links.sign_out")
    expect(current_path).to eq root_path
    expect(page).to have_content I18n.t("devise.sessions.signed_out")
  end

  scenario 'マイページを確認する' do
    visit "/users/auth/twitter"

    visit users_mypage_path
    expect(page).to have_content I18n.t("messages.users.twitter_user_login")
  end
end
