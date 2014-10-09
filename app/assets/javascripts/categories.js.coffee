# カテゴリの支出と収入を選択し、該当するカテゴリを表示する
$(document).on('page:change', (e) ->
  $(".categories_index .minus-sign").click ->
    set_categories(0)
  $(".categories_index .plus-sign").click ->
    set_categories(1)
)

$(document).on('ready page:load', (e) ->
  $(".categories_index input#category_barance_of_payments_0").val(["0"])
  if ($(".container").hasClass('categories_index')) then set_categories(0)
  if ($(".categories_edit .minus-sign").hasClass('active')) then $("input#category_barance_of_payments_0").val(["0"])
  if ($(".categories_edit .plus-sign").hasClass('active')) then $("input#category_barance_of_payments_1").val(["1"])
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

# カテゴリーの選択後に内訳のセレクトボックスを該当カテゴリーの内訳にする
$(document).on('page:change', (e) ->
  $("select#category_name").change( ->
    category_id = $("select#category_name option:selected").val()
    $.ajax({
      url: "set_breakdowns_from_category",
      type: "POST",
      data: category_id,
      success: (response) ->
      error: (response) -> alert("エラーが発生しました")
    })
  )
)
