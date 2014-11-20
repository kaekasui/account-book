require 'rails_helper'

feature 'Home' do
  let(:user) { create(:user, confirmed_at: Time.now, admin: true) }

  background do
    login user
  end

  scenario 'HOMEにフィードバックへの回答を表示する' do
    visit root_path
    fill_in 'feedback_content', with: "フィードバック内容"
    click_button I18n.t("buttons.send")

    feedback = Feedback.find_by_content("フィードバック内容")
    visit new_admin_feedback_answer_path(feedback_id: feedback.id)

    fill_in 'answer_content', with: "フィードバックの返信"
    click_button I18n.t("buttons.send")
    answer = Answer.find_by_content("フィードバックの返信")

    visit root_path
    click_link "フィードバックの返信"

    expect(current_path).to eq message_path(id: answer.id) 
    expect(page.body).to have_content("フィードバックの返信")
  end
end
