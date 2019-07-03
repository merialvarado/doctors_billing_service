module ApplicationHelper
  def tab_creator(label, path)
    active_class = request.path == path ? "active" : ""
    unless params[:active_tab].blank?
      active_class = params[:active_tab] == label ? "active" : ""
    end
    content_tag(:li, class: active_class) do
      content_tag(:a, label, href: path, class: "nav-item nav-link")
    end
  end
end
