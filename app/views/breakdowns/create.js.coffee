$("table.breakdown").prepend("<%= j render partial: 'breakdown', locals: { breakdown: @breakdown } %>")

$("input#breakdown_name").val("")
