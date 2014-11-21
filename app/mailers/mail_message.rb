class MailMessage < ActionMailer::Base
  default from: ENV['MAIL_USER_NAME']

  def register_instructions(email)
    @email = email
    mail(to: @email, bcc: ENV['MAIL_USER_NAME'])
  end
end
