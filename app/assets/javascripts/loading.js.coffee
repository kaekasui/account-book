$(document).on 'page:fetch', ->
  #$(".loading").html("<img src='/assets/loader.gif' width='60'>")
  $(".loading").html("<p class='loader-image' />")
  $(".main").hide()

$(document).on 'page:restore', ->
  $(".loading img").hide()
  $(".main").show()
