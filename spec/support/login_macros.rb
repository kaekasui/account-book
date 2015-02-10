module LoginMacros
  def login(user)
    visit root_path
    click_link I18n.t('links.sign_in')
    fill_in User.human_attribute_name(:email), with: user.email
    fill_in User.human_attribute_name(:password), with: user.password
    click_button I18n.t('buttons.sign_in')

    expect(current_path).to eq root_path
    expect(page).to have_content I18n.t('devise.sessions.signed_in')
  end
end
