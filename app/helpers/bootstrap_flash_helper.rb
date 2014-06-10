module BootstrapFlashHelper
  ALERT_TYPES = [:error, :info, :success, :warning] unless const_defined?(:ALERT_TYPES)

  def bootstrap_flash
    flash_messages = []
    flash.each do |type, message|
      next if message.blank?
      type = :success if type == :notice
      type = :error if type == :alert
      next unless ALERT_TYPES.include?(type)
      Array(message).each do |msg|
        text = content_tag(:div, content_tag(:button, raw("&times;"), :class => "close", "data-dismiss" => "alert", "aria-hidden" => true) + msg.html_safe, :class => "alert alert-dismissable alert-danger")
        flash_messages << text if msg
      end
    end
    flash_messages.join("\n").html_safe
  end
end
