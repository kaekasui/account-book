$(document).on 'page:fetch', ->
  #$(".loading").html("<img src='/assets/loader.gif' width='60'>")
  $(".loading").html("<p class='loader-image' />")
  $(".main").hide()
  $(".footer").hide()

$(document).on 'page:restore', ->
  $(".loading").hide()
  $(".main").show()
  $(".footer").show()
