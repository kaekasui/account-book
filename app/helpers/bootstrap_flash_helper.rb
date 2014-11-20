# Boostrap relationship modules
module BootstrapFlashHelper
  unless const_defined?(:ALERT_TYPES)
    ALERT_TYPES = [:error, :info, :success, :warning]
  end

  def bootstrap_flash
    flash_messages = []
    flash.each do |type, message|
      next if message.blank?
      type = change_type(type)
      next unless ALERT_TYPES.include?(type)
      Array(message).each do |msg|
        flash_messages << build_tag(msg) if msg
      end
    end
    flash_messages.join('\n').html_safe
  end

  private

  def change_type(type)
    :success if type == :notice
    :error if type == :alert
  end

  def build_tag(msg)
    content_tag(
      :div,
      content_tag(:button,
                  raw('&times;'),
                  :class => 'close',
                  'data-dismiss' => 'alert',
                  'aria-hidden' => true
      ) + msg.html_safe,
      class: 'alert alert-dismissable alert-danger')
  end
end
