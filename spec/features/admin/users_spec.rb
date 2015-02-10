require 'rails_helper'

feature '管理者：ユーザーの管理' do
  scenario '24時間以上経った認証待ちのメールアドレスを削除する' do
    user = create(:user, confirmed_at: Time.now, admin: true)
    login user

    # 認証待ちメールアドレス作成
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
    expect(user.reload.unconfirmed_email).to eq 'user2@example.com'

    # 管理者の処理（24時間以内）
    visit admin_users_path
    click_link I18n.t('links.destroy')
    expect(page).to have_content I18n.t('messages.users.delete_unconfirmed_email')
    expect(user.reload.unconfirmed_email).to eq 'user2@example.com'

    # 管理者の処理（24時間以上）
    user.confirmation_sent_at = Time.now - 25.hours
    user.save

    visit admin_users_path
    click_link I18n.t('links.destroy')
    expect(page).to have_content I18n.t('messages.users.delete_unconfirmed_email')
    expect(user.reload.unconfirmed_email).to be_nil
  end

  scenario 'ユーザーの一覧でユーザーの情報を表示する' do
    user = create(:user, confirmed_at: Time.now, admin: true)
    login user

    visit admin_users_path
    expect(page.body).to have_content(user.last_sign_in_at)
    expect(page.body).to have_content(user.email)
  end
end
