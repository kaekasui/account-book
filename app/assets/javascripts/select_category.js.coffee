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
