# 画面遷移後に、支出と収入のカテゴリのリストを表示する
$(document).on('ready page:load', (e) ->
  $(".categories_index input#category_barance_of_payments_0").val(["0"])
  if ($(".container").hasClass('categories_index')) then set_categories(0)
  if ($(".categories_edit .minus-sign").hasClass('active')) then $("input#category_barance_of_payments_0").val(["0"])
  if ($(".categories_edit .plus-sign").hasClass('active')) then $("input#category_barance_of_payments_1").val(["1"])
)

# カテゴリの支出と収入を選択し、該当するカテゴリのリストを表示する
$(document).on('page:change', (e) ->
  $(".categories_index .minus-sign").click ->
    set_categories(0)
  $(".categories_index .plus-sign").click ->
    set_categories(1)
)

# 画面遷移後に、支出と収入のカテゴリをセレクトボックスに表示する
$(document).on('ready page:load', (e) ->
  if ($(".container").hasClass('records_new') or $(".container").hasClass('records_create'))
    if getParam("category") == null
      set_categories_from_type(0)
)

# カテゴリの支出と収入を選択し、該当するカテゴリをセレクトボックスに表示する
$(document).on('page:change', (e) ->
  $(".records_new .minus-sign").click ->
    set_categories_from_type(0)
  $(".records_create .minus-sign").click ->
    set_categories_from_type(0)
  $(".records_edit .minus-sign").click ->
    set_categories_from_type(0)
  $(".records_update .minus-sign").click ->
    set_categories_from_type(0)
  $(".records_new .plus-sign").click ->
    set_categories_from_type(1)
  $(".records_create .plus-sign").click ->
    set_categories_from_type(1)
  $(".records_edit .plus-sign").click ->
    set_categories_from_type(1)
  $(".records_update .plus-sign").click ->
    set_categories_from_type(1)
)

# カテゴリーの選択後に、内訳のセレクトボックスを該当カテゴリーの内訳にする
$(document).on('page:change', (e) ->
  $("select#record_category_id").change( ->
    set_breakdowns_from_category()
  )
)

# 支出と収入それぞれのカテゴリを表示する
set_categories = (sign) ->
  category = {}
  category["barance_of_payments"] = sign
  $.ajax({
    url: "/categories/set_categories_list",
    type: "POST",
    beforeSend: (xhr) -> xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content')),
    data: category,
    headers: {
      'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content')
    },
    success: (response) ->
    error: (response) -> alert("error")
  })

# 選択した収支についてカテゴリをセレクトボックスに表示する
set_categories_from_type = (sign) ->
  category = {}
  category["barance_of_payments"] = sign
  $.ajax({
    url: "/categories/set_categories_box",
    type: "POST",
    beforeSend: (xhr) -> xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content')),
    data: category,
    headers: {
      'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content')
    },
    success: (response) ->
      set_breakdowns_from_category()
    error: (response) -> alert("error")
  })

# 選択したカテゴリの内訳をセレクトボックスに表示する
set_breakdowns_from_category = () ->
  category_id = $("select#record_category_id option:selected").val()
  if category_id
    $.ajax({
      url: "/records/set_breakdowns_from_category",
      type: "POST",
      data: category_id,
      success: (response) ->
      error: (response) -> alert("エラーが発生しました")
    })

# 入力時にカテゴリを登録する
$(document).on('ready page:load', (e) ->
  $("#create_category").click ( ->
    if !($("input[name='barance_of_payments']:checked").val())
      return
    if !($("input#name").val())
      return
    category = { category: {
      name: $('input#name').val(),
      barance_of_payments: $("input[name='barance_of_payments']:checked").val(),
      submit_type: "modal"
    }}
    $.ajax({
      url: "/categories",
      type: "POST",
      beforeSend: (xhr) -> xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content')),
      data: category,
      headers: {
        'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content')
      },
      success: (response) ->
        $('#create-category-modal').modal('hide')
        barance_of_payments = $("input[name='barance_of_payments']:checked").val()
        if barance_of_payments is "0"
          $('.minus-sign').click()
        else
          $('.plus-sign').click()
        $('select#record_category_id').prepend($('<option>').html(category.category.name).val(response))
        $('select#record_category_id').val(response)
        #set_breakdowns_from_category()
      error: (response) -> alert("error")
    })
  )
)

# GETパラメータの取得
getParam = (key) ->
  url = location.href
  parameters = url.split('?')
  paramsArray = []
  if !parameters[1]
    paramsArray[key] = null
  else
    params = parameters[1].split('&')
    for i in [0..(params.length - 1)]
      neet = params[i].split('=')
      paramsArray.push(neet[0]);
      paramsArray[neet[0]] = neet[1]
  paramsArray[key]
