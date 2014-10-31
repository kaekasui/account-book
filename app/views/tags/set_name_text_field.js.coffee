$("#<%= @tag.id %>.tag-name").html("<%= j render partial: "name_text_field", locals: { tag: @tag } %>")
$("#<%= @tag.id %>.tag-name").removeClass("tag-name")
$("input#tag_name.<%= @tag.id %>").focus()

$("span.tag-cancel-icon").click ->
  $("td#<%= @tag.id %>.name").html("<%= @tag.name %>")
  $("td#<%= @tag.id %>.name").addClass("tag-name")
  return false
