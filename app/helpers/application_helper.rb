module ApplicationHelper
  def page_title
    t("page_title.#{controller_path}.#{action_name}")
  end
end
