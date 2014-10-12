module ApplicationHelper
  def page_title
    t("page_title.#{controller_path}.#{action_name}")
  end

  def namespace
    controller.controller_path.split('/')[-2]
  end
end
