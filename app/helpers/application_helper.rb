module ApplicationHelper
  def render_flash_message(key)
    if flash[key]
      css_class = key == :notice ? "success" : "danger"
      content_tag :div, flash[key], class: "alert alert-#{css_class}"
    end
  end
end
