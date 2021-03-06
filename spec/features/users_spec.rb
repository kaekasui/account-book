require 'rails_helper'

feature 'ユーザーアカウントの管理' do
  scenario 'ログインする' do
    user = create(:user, confirmed_at: Time.now)
    login user

    expect(current_path).to eq root_path
    expect(page).to have_content I18n.t('devise.sessions.signed_in')
  end

  scenario 'ログインに失敗する' do
    user = create(:user, email: 'abc@example.com', confirmed_at: Time.now)

    visit root_path
    click_link I18n.t('links.sign_in')
    fill_in User.human_attribute_name(:email), with: 'aaa@example.com'
    fill_in User.human_attribute_name(:password), with: user.password
    click_button I18n.t('buttons.sign_in')

    expect(current_path).to eq new_user_session_path
    expect(page).to have_content I18n.t('devise.failure.invalid')
  end

  scenario 'ログアウトする' do
    user = create(:user, confirmed_at: Time.now)
    login user

    click_link I18n.t('links.sign_out')

    expect(current_path).to eq root_path
    expect(page).to have_content I18n.t('devise.sessions.signed_out')
  end

  scenario '新規会員登録をする' do
    visit root_path

    click_link I18n.t('links.sign_up')
    fill_in User.human_attribute_name(:email), with: 'new_user@example.com'
    fill_in User.human_attribute_name(:password), with: 'password'
    fill_in User.human_attribute_name(:password_confirmation), with: 'password'
    click_button I18n.t('buttons.sign_up')

    expect(current_path).to eq root_path
    expect(page).to have_content I18n.t('devise.registrations.signed_up_but_unconfirmed')

    user = User.find_by_email('new_user@example.com')
    open_email('new_user@example.com')
    mail_body = current_email.body
    index = mail_body.index('confirmation_token=')
    token = mail_body.slice(index + 19..index + 38)
    visit user_confirmation_path(confirmation_token: token)

    expect(current_path).to eq new_user_session_path

    fill_in User.human_attribute_name(:email), with: 'new_user@example.com'
    fill_in User.human_attribute_name(:password), with: 'password'
    click_button I18n.t('buttons.sign_in')

    expect(page).to have_content I18n.t('devise.sessions.signed_in')
  end

  scenario '新規会員登録に失敗する' do
    visit root_path
    click_link I18n.t('links.sign_up')
    fill_in User.human_attribute_name(:email), with: 'new_user@example.com'
    fill_in User.human_attribute_name(:password), with: 'password'
    fill_in User.human_attribute_name(:password_confirmation), with: ''
    click_button I18n.t('buttons.sign_up')

    expect(current_path).to eq user_registration_path
  end

  scenario 'ユーザー情報を更新する' do
    user = create(:user, confirmed_at: Time.now)
    login user

    click_link I18n.t('links.status')
    click_link I18n.t('links.edit_user')
    fill_in User.human_attribute_name(:email), with: user.email
    fill_in User.human_attribute_name(:password), with: '12345678'
    fill_in User.human_attribute_name(:password_confirmation), with: '12345678'
    fill_in User.human_attribute_name(:current_password), with: user.password
    click_button I18n.t('buttons.update')
    expect(page).to have_content I18n.t('devise.registrations.updated')
    expect(current_path).to eq users_mypage_path
  end

  scenario '新規会員登録で確認メールを再送し登録する' do
    visit root_path

    click_link I18n.t('links.sign_up')
    fill_in User.human_attribute_name(:email), with: 'new_user@example.com'
    fill_in User.human_attribute_name(:password), with: 'password'
    fill_in User.human_attribute_name(:password_confirmation), with: 'password'
    click_button I18n.t('buttons.sign_up')

    expect(current_path).to eq root_path
    expect(page).to have_content I18n.t('devise.registrations.signed_up_but_unconfirmed')

    visit new_user_session_path
    click_link I18n.t('links.confirmation')

    expect(current_path).to eq new_user_confirmation_path

    fill_in User.human_attribute_name(:email), with: 'new_user@example.com'
    click_button I18n.t('buttons.send_email')

    expect(page).to have_content I18n.t('devise.confirmations.send_instructions')

    user = User.find_by_email('new_user@example.com')
    open_email('new_user@example.com')
    mail_body = current_email.body
    index = mail_body.index('confirmation_token=')
    token = mail_body.slice(index + 19..index + 38)
    visit user_confirmation_path(confirmation_token: token)

    expect(current_path).to eq new_user_session_path

    fill_in User.human_attribute_name(:email), with: 'new_user@example.com'
    fill_in User.human_attribute_name(:password), with: 'password'
    click_button I18n.t('buttons.sign_in')

    expect(page).to have_content I18n.t('devise.sessions.signed_in')
  end

  scenario 'パスワードを再設定する' do
    user = create(:user, confirmed_at: Time.now)

    visit new_user_session_path
    click_link I18n.t('links.reset_password')

    expect(current_path).to eq new_user_password_path

    fill_in User.human_attribute_name(:email), with: 'user@example.com'
    click_button I18n.t('buttons.send_email')

    expect(page).to have_content I18n.t('devise.passwords.send_instructions')

    open_email('user@example.com')
    mail_body = current_email.body
    index = mail_body.index('reset_password_token=')
    token = mail_body.slice(index + 21..index + 40)
    visit edit_user_password_path(reset_password_token: token)

    fill_in User.human_attribute_name(:password), with: 'new_password'
    fill_in User.human_attribute_name(:password_confirmation), with: 'new_password'
    click_button I18n.t('buttons.change_password')

    expect(current_path).to eq root_path
    expect(page).to have_content I18n.t('devise.passwords.updated')
  end

  scenario '退会する' do
    user = create(:user, confirmed_at: Time.now)
    login user

    visit users_mypage_path
    click_link I18n.t('links.cancel_user')

    fill_in Cancel.human_attribute_name(:content), with: '退会理由'
    click_button I18n.t('buttons.cancel')

    expect(current_path).to eq root_path
    expect(page).to have_content I18n.t('devise.registrations.destroyed')
  end

  scenario 'マイページを確認する' do
    user = create(:user, confirmed_at: Time.now)
    login user

    visit users_mypage_path
    expect(page).to have_content I18n.t('messages.users.original_user_login')
  end

  scenario 'メールアドレスを変更する' do
    user = create(:user, confirmed_at: Time.now)
    login user

    visit users_mypage_path
    click_link I18n.t('links.edit_user')
    click_link I18n.t('links.edit_email')
    expect(current_path).to eq users_edit_email_path
    expect(user.email).to have_content 'user@example.com'

    # 同じメールアドレスを入力した場合
    fill_in User.human_attribute_name(:email), with: 'user@example.com'
    within 'form#edit_user' do
      click_button I18n.t('buttons.send')
    end
    expect(page).to have_content I18n.t('messages.users.same')
    expect(current_path).to eq users_update_email_path

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
    expect(user.reload.email).to have_content 'user2@example.com'
  end

  scenario '認証待ちのメールアドレスを削除する' do
    user = create(:user, confirmed_at: Time.now)
    login user

    visit users_mypage_path
    click_link I18n.t('links.edit_user')
    click_link I18n.t('links.edit_email')
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
    user = create(:user, confirmed_at: Time.now)
    login user

    visit users_mypage_path
    click_link I18n.t('links.edit_user')
    click_link I18n.t('links.edit_email')
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

  scenario '登録済みのメールアドレスで新規登録できないこと' do
    create(:user, confirmed_at: Time.now)

    # 新規登録
    visit root_path
    click_link I18n.t('links.sign_up')
    fill_in User.human_attribute_name(:email), with: 'user@example.com'
    fill_in User.human_attribute_name(:password), with: 'password'
    fill_in User.human_attribute_name(:password_confirmation), with: 'password'
    click_button I18n.t('buttons.sign_up')
    expect(current_path).to eq user_registration_path
    expect(page).to have_content I18n.t('errors.messages.taken', :email)
  end

  scenario '退会後の再登録でメール確認からの登録があること' do
    user = create(:user, confirmed_at: Time.now)
    login user

    visit users_mypage_path
    click_link I18n.t('links.cancel_user')

    fill_in Cancel.human_attribute_name(:content), with: '退会理由'
    click_button I18n.t('buttons.cancel')

    expect(current_path).to eq root_path
    expect(page).to have_content I18n.t('devise.registrations.destroyed')

    # 再登録
    click_link I18n.t('links.sign_up')
    fill_in User.human_attribute_name(:email), with: 'user@example.com'
    fill_in User.human_attribute_name(:password), with: 'password'
    fill_in User.human_attribute_name(:password_confirmation), with: 'password'
    click_button I18n.t('buttons.sign_up')
    expect(current_path).to eq root_path
    expect(page).to have_content I18n.t('devise.registrations.signed_up_but_unconfirmed')

    user = User.find_by_email('user@example.com')
    open_email('user@example.com')
    mail_body = current_email.body
    index = mail_body.index('confirmation_token=')
    token = mail_body.slice(index + 19..index + 38)
    visit user_confirmation_path(confirmation_token: token)

    expect(current_path).to eq new_user_session_path

    fill_in User.human_attribute_name(:email), with: 'user@example.com'
    fill_in User.human_attribute_name(:password), with: 'password'
    click_button I18n.t('buttons.sign_in')

    expect(page).to have_content I18n.t('devise.sessions.signed_in')
  end
end
