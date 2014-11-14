module ApplicationHelper
  def page_title
    t("page_title.#{controller_path}.#{action_name}")
  end

  def namespace
    controller.controller_path.split('/')[-2]
  end

  def setting_menu?
    ['categories', 'breakdowns', 'places', 'tags'].include?(controller_name)
  end

  def asterisk
    content_tag(:font, ' ※ ', class: 'red')
  end
end
