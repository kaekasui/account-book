$("#<%= @tag.id %>.tag-color-code").html("<%= j render partial: "color_code_text_field", locals: { tag: @tag } %>")
$("#<%= @tag.id %>.tag-color-code").removeClass("tag-color-code")
$("input#tag_color_code.<%= @tag.id %>").focus()

$("span.tag-cancel-icon").click ->
  $("td#<%= @tag.id %>.color-code").html("<%= @tag.color_code %>")
  $("td#<%= @tag.id %>.color-code").addClass("tag-color-code")
  return false
