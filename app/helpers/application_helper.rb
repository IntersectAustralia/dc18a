module ApplicationHelper
  def title(page_title)
    content_for(:title) { page_title }
  end

  # convenience method to render a field on a view screen - saves repeating the div/span etc each time
  def render_field(label, value, span = 3)
    render_field_content(label, (h value), span)
  end

  def render_field_if_not_empty(label, value)
    render_field_content(label, (h value)) if value != nil && !value.empty?
  end

  # as above but takes a block for the field value
  def render_field_with_block(label, &block)
    content = with_output_buffer(&block)
    render_field_content(label, content)
  end

  def administration_dropdown_menu
    "Administration<b class=\"caret\"></b>".html_safe
  end

  def user_dropdown_menu
    "#{h current_user.full_name}<b class=\"caret\"></b>".html_safe
  end

  def sortable(column, title = nil)
    title ||= column.titleize
    css_class = column == sort_column ? "current #{sort_direction}" : nil
    direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
    link_to title, {:sort => column, :direction => direction}, :class => css_class
  end

  private
  def render_field_content(label, content, span = 3)
    div_class = cycle("field_bg","field_nobg")
    div_id = label.tr(" ,/", "_").downcase
    html = "<div class='#{div_class} inlineblock row' id='display_#{div_id}'>"
    html << "<strong class='span#{span}'>"
    html << (h label)
    html << ":"
    html << '</strong>'
    html << "<span class='span#{12 - span}'>"
    html << content
    html << '</span>'
    html << '</div>'
    html.html_safe
  end


end
