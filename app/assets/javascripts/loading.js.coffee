$(document).on 'page:fetch', ->
  $(".loading").html("<img src='/assets/loader.gif' width='60'>")
  $(".main").hide()

$(document).on 'page:restore', ->
  $(".loading img").hide()
  $(".main").show()
