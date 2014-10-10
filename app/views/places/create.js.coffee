$("table.place").prepend("<%= j render partial: 'place', locals: { place: @place } %>")

$("input#place_name").val("")
