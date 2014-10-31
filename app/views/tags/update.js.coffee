if "<%= @color_code.present? %>" == "true"
  $("td#<%= @tag.id %>.color-code").html("<%= @color_code %>")
  $("td#<%= @tag.id %>.color-code").addClass("tag-color-code")
  $("td#<%= @tag.id %>.color-code-icon").css("color", "<%= @color_code %>")
if "<%= @name.present? %>" == "true"
  $("td#<%= @tag.id %>.name").html("<%= @name %>")
  $("td#<%= @tag.id %>.name").addClass("tag-name")
