color_code = "<%= @tag.errors[:color_code].any? %>"
name = "<%= @tag.errors[:name].any? %>"

if color_code == "true"
  $("input#tag_color_code.<%= @tag.id %>").popover(placement: "top", content: "<%= @tag.errors.full_message(:color_code, @tag.errors[:color_code].first) %>")
  $("input#tag_color_code.<%= @tag.id %>").click()

if name == "true"
  $("input#tag_name.<%= @tag.id %>").popover(placement: "top", content: "<%= @tag.errors.full_message(:name, @tag.errors[:name].first) %>")
  $("input#tag_name.<%= @tag.id %>").click()
