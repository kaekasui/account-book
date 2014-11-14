# Administrator manages all users.
class Admin::UsersController < Admin::AdminBaseController
  respond_to :html

  def index
    @admin_users = User.all
  end

  def delete_unconfirmed_email
    users = User.where('unconfirmed_email is not null and confirmation_sent_at < ?', Time.now - 24.hours)
    users.each do |user|
      user.update_attributes!(unconfirmed_email: nil)
    end
    flash[:notice] = users.count.to_s + I18n.t('labels.of_count') + I18n.t('messages.users.delete_unconfirmed_email')
    rescue
    flash[:alert] = I18n.t('messages.errors.delete_unconfirmed_email')
    ensure
    redirect_to admin_users_path
  end
end
