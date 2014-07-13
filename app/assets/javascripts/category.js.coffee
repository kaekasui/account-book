$(document).on('page:change', (e) ->
  $(".minus-sign").click ->
    set_categories(0)
  $(".plus-sign").click ->
    set_categories(1)
)

$(document).on('ready page:load', (e) ->
  $(".container.categories_index").on('ready page:load', (e) ->
    $("input#category_barance_of_payments_0").val(["0"])
    set_categories(0)
  )
)

set_categories = (sign) ->
  category = {}
  category["barance_of_payments"] = sign
  $.ajax({
    url: "categories/set_categories_list",
    type: "POST",
    beforeSend: (xhr) -> xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content')),
    data: category,
    headers: {
      'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content')
    },
    success: (response) ->
    error: (response) -> alert("error")
  })
