color_code = "<%=  @tag.errors[:color_code].any? %>"
name = "<%= @tag.errors[:name].any? %>"

if color_code == "true"
  $('#tag_color_code').popover(placement: "bottom", content: "<%= @tag.errors.full_message(:color_code, @tag.errors[:color_code].first) %>")
  $('#tag_color_code').click()

if name == "true"
  $('#tag_name').popover(placement: "bottom", content: "<%= @tag.errors.full_message(:name, @tag.errors[:name].first) %>")
  $('#tag_name').click()
