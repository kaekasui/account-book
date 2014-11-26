$(document).on('ready page:load', (e) ->
  $("td.tag-color-code").click ->
    if ($(this).hasClass('tag-color-code'))
      set_color_code_text_field(this)
  $("td.tag-name").click ->
    if ($(this).hasClass('tag-name'))
      set_name_text_field(this)
  if ($(".container").hasClass('records_new'))
    set_new_tags()
  if ($(".container").hasClass('records_create'))
    set_new_tags()
  if ($(".container").hasClass('records_edit'))
    set_new_tags()
  if ($(".container").hasClass('records_update'))
    set_new_tags()
  if ($(".container").hasClass('records_copy'))
    set_new_tags()
) 

set_color_code_text_field = (field) ->
  tag_id = $(field).attr('id')
  $.ajax({
    url: "/tags/set_color_code_text_field",
    type: "POST",
    beforeSend: (xhr) -> xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content')),
    data: { id: tag_id },
    headers: {
      'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content')
    },
    success: (response) ->
    error: (response) -> alert("error")
  })

set_name_text_field = (field) ->
  tag_id = $(field).attr('id')
  $.ajax({
    url: "/tags/set_name_text_field",
    type: "POST",
    beforeSend: (xhr) -> xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content')),
    data: { id: tag_id },
    headers: {
      'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content')
    },
    success: (response) ->
    error: (response) -> alert("error")
  })

set_new_tags = () ->
  $.ajax({
    url: "/tags/get_tags",
    type: "GET",
    beforeSend: (xhr) -> xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content')),
    data: "",
    headers: {
      'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content')
    },
    success: (response) ->
      if ($(".container").hasClass('records_new'))
        $("#record_tagged").val("")
      $("#record_tagged").select2({ tags: eval(response) })
    error: (response) -> alert("error")
  })
