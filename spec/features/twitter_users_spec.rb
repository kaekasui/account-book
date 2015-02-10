require 'rails_helper'

feature 'Twitterアカウントの管理' do
  scenario 'ログインする' do
    visit '/users/auth/twitter'

    expect(current_path).to eq root_path
    expect(page).to have_content I18n.t('devise.omniauth_callbacks.success', kind: 'twitter')
  end

  scenario 'ログインする(2回目)' do
    visit '/users/auth/twitter'

    expect(current_path).to eq root_path
    expect(page).to have_content I18n.t('devise.omniauth_callbacks.success', kind: 'twitter')
    click_link I18n.t('links.sign_out')

    visit '/users/auth/twitter'
    expect(current_path).to eq root_path
    expect(page).to have_content I18n.t('devise.omniauth_callbacks.success', kind: 'twitter')
  end

  scenario 'ログアウトする' do
    visit '/users/auth/twitter'

    expect(current_path).to eq root_path
    expect(page).to have_content I18n.t('devise.omniauth_callbacks.success', kind: 'twitter')

    click_link I18n.t('links.sign_out')
    expect(current_path).to eq root_path
    expect(page).to have_content I18n.t('devise.sessions.signed_out')
  end

  scenario 'マイページを確認する' do
    visit '/users/auth/twitter'

    visit users_mypage_path
    expect(page).to have_content I18n.t('messages.users.twitter_user_login')
  end

  scenario '退会する' do
    visit '/users/auth/twitter'
    visit users_mypage_path
    expect(page).to have_content I18n.t('messages.users.twitter_user_login')
    visit cancel_user_registration_path

    fill_in Cancel.human_attribute_name(:content), with: '退会理由'
    click_button I18n.t('buttons.cancel')

    expect(current_path).to eq root_path
    expect(page).to have_content I18n.t('devise.registrations.destroyed')
  end

  scenario '退会後にログインする' do
    visit '/users/auth/twitter'
    visit users_mypage_path
    expect(page).to have_content I18n.t('messages.users.twitter_user_login')
    visit cancel_user_registration_path

    fill_in Cancel.human_attribute_name(:content), with: '退会理由'
    click_button I18n.t('buttons.cancel')

    expect(current_path).to eq root_path
    expect(page).to have_content I18n.t('devise.registrations.destroyed')

    visit '/users/auth/twitter'
    visit users_mypage_path
    expect(page).to have_content I18n.t('messages.users.twitter_user_login')
  end

  scenario 'メールアドレスを変更する' do
    visit '/users/auth/twitter'
    visit users_mypage_path
    click_link I18n.t('buttons.create')
    expect(current_path).to eq users_edit_email_path

    # 空のメールアドレスを入力した場合
    fill_in User.human_attribute_name(:email), with: ''
    within 'form#edit_user' do
      click_button I18n.t('buttons.send')
    end
    expect(current_path).to eq users_update_email_path
    expect(page).to have_content I18n.t('errors.messages.blank')

    # 再度別メールアドレスを入力した場合
    fill_in User.human_attribute_name(:email), with: 'user2@example.com'
    within 'form#edit_user' do
      click_button I18n.t('buttons.send')
    end
    expect(page).to have_content I18n.t('devise.registrations.confirmed')
    expect(current_path).to eq users_mypage_path
    expect(page).to have_selector('.unconfirmed_email', text: (I18n.t('labels.unconfirmed_email') + I18n.t('code.colon') + ' user2@example.com'))

    open_email('user2@example.com')
    mail_body = current_email.body
    index = mail_body.index('confirmation_token=')
    token = mail_body.slice(index + 19..index + 38)
    visit user_confirmation_path(confirmation_token: token, confirmation_type: 'edit')

    expect(current_path).to eq users_mypage_path
    expect(page).to have_content I18n.t('devise.confirmations.update_email')
    expect(page).to have_content 'user2@example.com'
  end

  scenario '認証待ちのメールアドレスを削除する' do
    visit '/users/auth/twitter'
    visit users_mypage_path
    click_link I18n.t('buttons.create')
    expect(current_path).to eq users_edit_email_path

    fill_in User.human_attribute_name(:email), with: 'user2@example.com'
    within 'form#edit_user' do
      click_button I18n.t('buttons.send')
    end
    expect(page).to have_content I18n.t('devise.registrations.confirmed')
    expect(current_path).to eq users_mypage_path
    expect(page).to have_selector('.unconfirmed_email', text: (I18n.t('labels.unconfirmed_email') + I18n.t('code.colon') + ' user2@example.com'))

    click_link I18n.t('links.destroy')
    expect(current_path).to eq users_mypage_path
    expect(page).to have_content I18n.t('messages.users.delete_an_unconfirmed_email')
  end

  scenario '認証待ちのメールアドレスにメールを再送する' do
    visit '/users/auth/twitter'
    visit users_mypage_path
    click_link I18n.t('buttons.create')
    expect(current_path).to eq users_edit_email_path

    fill_in User.human_attribute_name(:email), with: 'user2@example.com'
    within 'form#edit_user' do
      click_button I18n.t('buttons.send')
    end
    expect(page).to have_content I18n.t('devise.registrations.confirmed')
    expect(current_path).to eq users_mypage_path
    expect(page).to have_selector('.unconfirmed_email', text: (I18n.t('labels.unconfirmed_email') + I18n.t('code.colon') + ' user2@example.com'))

    click_link I18n.t('links.resend')
    expect(current_path).to eq users_mypage_path
    expect(page).to have_content I18n.t('devise.registrations.confirmed')
  end
end
