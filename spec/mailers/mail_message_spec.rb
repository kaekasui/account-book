require "rails_helper"

RSpec.describe MailMessage, :type => :mailer do
  describe "register_instructions" do
    let(:user) { create(:user, confirmed_at: Time.now) }
    let(:mail) { MailMessage.register_instructions(user.email) }

    it "ヘッダ情報" do
      expect(mail.subject).to eq I18n.t('mail_message.register_instructions.subject')
      expect(mail.from).to eq([ENV['MAIL_USER_NAME']])
      #expect(mail.to).to eq(["to@example.org"])
    end
  end
end
