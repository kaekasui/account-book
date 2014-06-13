$("table.category").prepend("<%= j render partial: 'category', locals: { category: @category } %>")

$("input#category_name").val("")
